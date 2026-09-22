\*TO_ compare Which customers have sigificant account balance 
relatively little transactions activity. to achieve this
we must combine different tables containing each customer account_id,name,transactions etc..
AIM:to_ help banks understand inactive deposits *\
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