\*Which customer card_ and_ merchant categories has
the highest number_ and_value of fraudulent transactions
PURPOSE: To_ identify patterns in_ fraudulent card_activity
and_ determine which customer_and merchant
categories are associated with_the highest fraud
exposure*\
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



