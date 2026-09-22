COPY public.Customers
FROM 'C:\My_sql_war\archive (5)\customers.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING'UTF8');

COPY public.Branches
FROM 'C:\My_sql_war\archive (5)\branches.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING'UTF8');

COPY public.Bank_account
FROM 'C:\My_sql_war\archive (5)\accounts.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING'UTF8');

COPY public.Cards
FROM 'C:\My_sql_war\archive (5)\cards.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING'UTF8');

COPY public.Card_transactions
FROM 'C:\My_sql_war\archive (5)\card_transactions.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING'UTF8');

COPY public.Employees
FROM 'C:\My_sql_war\archive (5)\employees.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING'UTF8');

COPY public.Loan
FROM 'C:\My_sql_war\archive (5)\loans.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING'UTF8');

COPY public.Loan_payments
FROM 'C:\My_sql_war\archive (5)\loan_payments.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING'UTF8');

COPY public.Support_ticket
FROM 'C:\My_sql_war\archive (5)\support_tickets.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING'UTF8');

COPY public.Transactions 
FROM 'C:\My_sql_war\archive (5)\transactions.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING'UTF8');
