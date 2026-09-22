\*How do branches compare in_terms of Employees,
customer accounts,and_total account balances
AIM: tO_examine branch sizes and_finanical responsibility 
by_comparing Employees,customer account and_transaction
activity they handle etc..... *\
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