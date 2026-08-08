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