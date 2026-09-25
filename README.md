# Introduction
This project is hands-on SQL data analytics project built around a simulated banking database obtained
from a reliable source **Kaggle**. The goal is to use PostgreSQL to explore Customser accounts,
transactions,cards,loans,branches,employees, and loan payments to better mointor banking activities.

SQL queries? check the link provided here:[bank_dataset_analysis](bank_dataset_analysis)
# Background
Coming from a Biochemistry background, i developed a strong interest in working with data buiding skills
in Excel,Power BI,& SQL. for this project i chose a banking dataset to enable me move beyond isolated SQL exercises into answering 
actual questions and generate meaningful insights.

### The questions i wanted to answer through my SQL queries were:
1. How do branches compare in terms of Employees,customser account and total sum holdings?
2. identifying number of accounts with highest value of fraudlent transactions ? by knowing the date,card_type, & marchant purchased 
3. which loans have recieved the most payments and which has outstandings alongside their term_months?
4. Customsers with siginificant account balance and low transactional activties ? to see inactive deposits


# Tools used
For my analysis into this banking dataset i harnessed the power of several key tools:
- SQL: this is the backbone of my analysis using it to query, and extract insights from data.
- PostgresSQL: Used for database management and my sql query command execution.
- Visual Studio Code: writing and organizing SQL scripts.
- Github: Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.
- Chatgpt: Used as my personal assistant with debugging, understanding SQL concepts, corrections and problem solving.


# Analysis
Each query for this project is aimed at investigating specific aspects of this banking data set .

Heres how i approached the project:

First started off by creating my dataset tables , column names and properly making sure each tables they are both linked to each other:
```SQL
CREATE TABLE public.Customers
(customer_id INT PRIMARY KEY,name VARCHAR(30),
gender VARCHAR(20),date_of_birth DATE,
city VARCHAR(30),state VARCHAR(30),phone TEXT,
email TEXT,occupation VARCHAR(30),
annual_income NUMERIC,join_date DATE,credit_score INT);

CREATE TABLE public.Branches
(branch_id INT PRIMARY KEY,
branch_name VARCHAR(30),city VARCHAR(30),
state  VARCHAR(30),opened_date DATE,ifsc_code TEXT);


CREATE TABLE public.Bank_account
(account_id INT PRIMARY KEY,customer_id INT,branch_id INT,
account_type VARCHAR(30),
balance NUMERIC,open_date DATE,status VARCHAR(30),
FOREIGN KEY(customer_id) REFERENCES public.Customers(customer_id),
FOREIGN KEY(branch_id) REFERENCES public.Branches(branch_id));


CREATE TABLE public.Cards
(card_id INT PRIMARY KEY,
customer_id INT,account_id INT,
card_type VARCHAR(30),issue_date DATE,
expiry_date DATE,credit_limit NUMERIC,
status VARCHAR(20),
FOREIGN KEY (account_id) REFERENCES public.Bank_account(account_id),
FOREIGN KEY (customer_id) REFERENCES public.Customers(customer_id)
);


CREATE TABLE public.Card_transactions
(card_txn_id INT PRIMARY KEY,
card_id INT,txn_date DATE,merchant_category VARCHAR(30),
amount NUMERIC,is_fraud INT,
FOREIGN KEY(card_id) REFERENCES public.Cards(card_id));

CREATE TABLE public.Employees
(employee_id INT PRIMARY KEY,
name VARCHAR(30),branch_id INT,role VARCHAR(40),
hire_date DATE,salary NUMERIC,
FOREIGN KEY(branch_id) REFERENCES public.Branches(branch_id));

CREATE TABLE public.Loan
(loan_id INT PRIMARY KEY,customer_id INT,
branch_id INT,loan_type VARCHAR(30),loan_amount NUMERIC,
interest_rate NUMERIC,term_months INT,
start_date DATE,status VARCHAR(20),
FOREIGN KEY (customer_id) REFERENCES public.Customers(customer_id),
FOREIGN KEY(branch_id) REFERENCES public.Branches(branch_id));


CREATE TABLE public.Loan_payments
(payment_id INT PRIMARY KEY,loan_id INT,
payment_date DATE,amount_paid NUMERIC,
principal_component NUMERIC,
interest_component NUMERIC,late_payment_flag INT,
FOREIGN KEY(loan_id) REFERENCES public.Loan(loan_id));


CREATE TABLE public.Support_ticket
(ticket_id INT PRIMARY KEY,customer_id INT,
issue_type VARCHAR(30),date_opened DATE,date_resolved DATE,
status VARCHAR(20),satisfaction_score INT,
FOREIGN KEY(customer_id) REFERENCES public.Customers);

CREATE TABLE public.Transactions
(transaction_id INT PRIMARY KEY,account_id INT,
txn_date DATE,txn_type VARCHAR(30),
amount NUMERIC,channel VARCHAR(30),
merchant_category VARCHAR(30),
FOREIGN KEY(account_id) REFERENCES public.Bank_account(account_id));

CREATE INDEX idx_customer_id ON public.Customers(customer_id);
CREATE INDEX idx_account_id ON public.Bank_account(account_id);
CREATE INDEX idx_branch_id ON public.Branches(branch_id);
CREATE INDEX idx_card_id ON public.Cards(card_id);
CREATE INDEX idx_card_txn_id ON public.Card_transactions(card_txn_id);
CREATE INDEX idx_employee_id ON public.Employees(employee_id);
CREATE INDEX idx_loan_id ON public.Loan(loan_id);
CREATE INDEX idx_payment_id ON public.Loan_payments(payment_id);
CREATE INDEX idx_ticket_id ON public.Support_ticket(ticket_id);
CREATE INDEX idx_transaction_id ON public.Transactions(transaction_id);
```
### 1. How do branches compare in terms of Employees,customser account and total sum holdings
To examine branch sizes and finanical responsibility 
by comparing Employees,customer account and transaction
activity they handle etc, i joined tables containing Employees, account and customser and branch info to filter this information.
```SQL
SELECT DISTINCT 
B.branch_name,
COUNT (DISTINCT E.employee_id) AS Employees_count,
COUNT(DISTINCT Account.account_id) AS Customers_count,
SUM(DISTINCT Account.balance) AS Total_acc_balance,
RANK() OVER(ORDER BY SUM(DISTINCT Account.balance)DESC) AS 
Networth_rank
FROM
public.branches AS B
INNER JOIN public.Employees AS E ON
E.branch_id=B.branch_id
INNER JOIN public.bank_account AS Account
ON Account.branch_id=B.branch_id
GROUP BY 
B.branch_name
ORDER BY 
Networth_rank ASC;
```

One row per bank branch. It tells us how big each branch is (staff, customers, money) and how the branches rank.

![Branch chart](https://github.com/Richard23-alt/Richards__sql_analysis/blob/488e40dc21e21bac381f1e22dad27ea768ccd4e3/Custom%20Office%20Templates/branch_balance_chart.png)

## Findings

1. **Branches come in four sizes.** The chart shows four clear groups, with nothing in between:

   | Size group | Branches | Average staff | Share of all money |
   |---|---|---|---|
   | About 650 customers | 55 | 12 | 37% |
   | About 1,250 customers | 21 | 24 | 28% |
   | About 1,900 customers | 15 | 36 | 30% |
   | About 2,500 customers | 2 | 49 | 5% |

   the four groups above represents its size 55 large group branches, 21 medium, 15 large and 2 Extra large groups marking a total of
   93 branches
   
### Facts
- 15 cities, 93 branches
- 1,800 employees and 95,000 active customers in total
- About 4.35 billion held in accounts across all branches

Top 5 Ranking cities by total balance:

| City | Branches | Customers | Total balance |
|---|---|---|---|
| Bhopal | 7 | 11,220 | 512M |
| Kolkata | 7 | 9,374 | 421M |
| Kochi | 8 | 8,866 | 408M |
| Pune | 6 | 7,607 | 344M |
| Jaipur | 7 | 7,024 | 328M |


## Insight
Due to multiple repeating name the branches was grouped into four however all four are operational in 15 cities but out of 15 about 5 stood out
Bhopal, Kolkata, Kochi, Pune, Jaipur.


Every customser keeps almost the same amount of money which is about 45,700 each. meaning branches with more customser has more money, other 
major cities like Chennai,Hyderabad, Ahmedabad puna, and kolkata have steady busy branches looking after about 1,950 customers with effective
empolyees on ground however on proper examination on average one worker looks after about 53 customers But at Chennai 1 worker looks after
127 customers

### ways to improve operations :
**Cut Extra Costs**

Some smaller local branches have up to 20 employees but serve fewer than 650 customers. we should look into downsizing those teams to save up cost since most bigger branches run smoothly with up to 6 to 8 employees. some of these teams can be transfered to hyderabad branch 4 
which has been recorded to have only one employee 


### 2. compare Which customers have sigificant account balance 
relatively little transactions activity. to achieve this
i combine different tables containing each customer account_id,name,transactions etc..
![Customer balance chart](https://github.com/Richard23-alt/Richards__sql_analysis/blob/8f4c956c34690ab5aa05b4a84b882f042aaeef12/Custom%20Office%20Templates/customer_balance_chart.png)

## What is in this SQL query
``` sql
SELECT
C.NAME,B.account_id,
TO_CHAR(amount,'FM$999,999,999.99') AS Formated_spent,
TO_CHAR(balance,'FM$999,999,999.99') AS Formated_Balance,
CASE
WHEN B.balance > 49000 THEN 'High_account_balance'
END AS Account_activity

FROM
public.customers  AS C
LEFT JOIN bank_account as B
ON B.customer_id=C.customer_id
LEFT JOIN transactions AS T 
ON B.account_id=T.account_id
WHERE
B.balance >49000 AND
T.amount < 1000
LIMIT
700
```

700 rows, 5 columns, no missing values.

| Column | Meaning |
|---|---|
| `name` | Customer name |
| `account_id` | Account number |
| `formated_spent` | Amount spent, stored as text (e.g. `$899.8`) |
| `formated_balance` | Account balance, stored as text (e.g. `$112,300.82`) |
| `account_activity` | Account label. Every single row says `High_account_balance` |

## Insights

1. Everyone is a high-balance customer The lowest balance is still about $49K, and the label agrees.
2. Most balances sit between $50K and $110K, with a long tail of a few very rich accounts (the chart leans to the left).
3. Customers spend very little compared with what they hold about 0.6% of their balance.
4. Spending has no link to balance. Rich accounts do not spend more than smaller ones (the link is almost zero, 0.01).
5. Spending is spread evenly from $50 to $1,000, with 72 customers spending over $900.

### Recommendation
- under observation i noticed 10 account IDs appear twice (20 rows). Each pair has the same name and balance but different `spent` amounts. this suggests individual have multiple accounts which lead may to fradulent transcation or application for multiple loans,
restriction to two accounts or creation of mutiple accounts for valid reasons should be followed up.

### 3. identify patterns in fraudulent card activity and_ determine which customer and merchant categories are associated with the highest fraud exposure

![Fraud list vs customers chart](https://github.com/Richard23-alt/Richards__sql_analysis/blob/8d140189388da52007ed215acaef3b1ad002555e/Custom%20Office%20Templates/fraud_vs_customer_chart.png)

## What is in this SQL query
```SQL
SELECT 
C.name,
Cd.card_id,Ct.merchant_category,Ct.is_fraud,
Ct.txn_date,Cd.card_type
FROM
public.Cards AS Cd 
INNER JOIN public.Customers AS C
ON C.customer_id=Cd.customer_id 
INNER JOIN public.Card_transactions AS Ct
ON Ct.card_id=Cd.card_id
WHERE
Ct.is_fraud= 1
```

700 rows, 5 columns, no missing values.

| Column | Meaning |
|---|---|
| `name` | Account holder name |
| `account_id` | Account number |
| `formated_spent` | Amount spent, stored as text (e.g. `$741.53`) |
| `formated_balance` | Account balance, stored as text (e.g. `$135,179.16`) |
| `account_activity` | Account label. Every single row says `High_account_balance` |
| `card_type`| type of card mostly used during this activity|

### Insights

1. The fraud list may look like the normal customer list how ever its the list of fraud accounts. Balances, spending and the label are all very similar. The blue and red bars in the chart follow the same shape.
2. The two SQL query(one above and this current one)  share accounts. 61 account IDs appear in both this SQL and , with the same name and the same balance.
3. I notced this fraud is most common among mutiple account holders

### Recommendation
same as documented in the pervious SQL.


### 4. which loans have recieved the most payments and which loans still have a large outstanding balance

![Loan repayment chart](https://github.com/Richard23-alt/Richards__sql_analysis/blob/a9c7564fb05a32dbdb74394ba8d48a5e61823916/Custom%20Office%20Templates/loan_repaid_chart.png)

## What is in this SQL query
```SQL
SELECT
C.name,
TO_CHAR(SUM(loan_amount),'FM$999,999,999.99') AS 
Formated_loan_amt,
TO_CHAR(SUM(amount_paid),'FM$999,999,999.99') AS Total_paid,
COUNT(payment_date) AS Count_pay,
L.term_months
FROM 
public.Customers AS C
INNER JOIN public.loan AS L
ON L.customer_id=C.customer_id
INNER JOIN public.Loan_payments AS LP 
ON LP.loan_id=L.loan_id
GROUP BY 
C.name,L.term_months
```

8,751 rows, 5 columns, no missing values.

| Column | Meaning |
|---|---|
| `name` | Borrower name |
| `formated_loan_amt` | Loan amount, stored as text (e.g. `$24,342,240.4`) |
| `total_paid` | Total repaid so far, stored as text |
| `count_pay` | Number of payments made (11 to 278) |
| `term_months` | Loan length in months |

## Insights

1. Only about 2.5% of the loan money has been repaid. For half of all loans, less than 3% is repaid.
2. Small loans are repaid faster. Loans under $1M are typically 36% repaid, while loans over $60M are typically only 1.6% repaid (see the chart).
3. Every payment is about the same size (about $10K), whatever the loan size. That is why big loans move so slowly.
4. Total paid depends on the number of payments made, not on the loan size .
5. Loan length has no effect on loan size. A 12-month loan is about as big as a 240-month loan (every loan length averages between $28M and $29M).
6.Big borrowers are not dominating. The top 10% of borrowers make up only 17% of the money lent.










# What I learnt
# Conclusion
