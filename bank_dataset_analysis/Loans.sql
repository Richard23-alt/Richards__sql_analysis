\*Loan payment performance: which loans have recieved
the most payments and_which loans still have 
a large outstanding balance
AIM: to_ analyze loan repayments made with_the
original loan amount*\
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