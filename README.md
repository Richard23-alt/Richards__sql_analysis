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

# What I learnt
# Conclusion
