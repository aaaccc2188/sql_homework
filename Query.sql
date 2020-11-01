-- How can you isolate (or group) the transactions of each cardholder?
SELECT *
FROM transaction_by_cardholder
WHERE id_card_holder = 3;

-- Consider the time period 7:00 a.m. to 9:00 a.m. What are the 100 highest transactions during this time period?
CREATE VIEW morning_transactions AS
SELECT *
FROM transaction_by_cardholder
WHERE EXTRACT(HOUR FROM date) > 6
AND EXTRACT(HOUR FROM date) < 9
ORDER BY amount DESC
LIMIT 100;

SELECT * FROM morning_transactions;
/* There might be fraudulent transactions during this time. Most of the transactions were small (less than $25), but there were 9 transactions at over $100 (7 of which were
over $1000) from bars/restaurants/coffee shops. Among these, there were multiple high-value transactions from 3 cardholders and 2 transactions from the same merchant */

-- Count the transactions that are less than $2.00 per cardholder. Is there any evidence to suggest that a credit card has been hacked? Explain your rationale.
CREATE VIEW small_transactions AS
SELECT id_card_holder, COUNT(id_card_holder)
FROM transaction_by_cardholder
WHERE amount < 2
GROUP BY id_card_holder
ORDER BY count DESC;

SELECT * FROM small_transactions;
/* While there were a few cardholders had a relatively higher number of small transactions, they did not appear to be excessive and thus not enough evidence to suggest a
credit card had been hacked. */

-- What are the top five merchants prone to being hacked using small transactions?
CREATE VIEW small_transactions_top_5_merchant AS
SELECT name_merchant, name_merchant_category, COUNT(name_merchant)
FROM transaction_by_cardholder
WHERE amount < 2
GROUP BY name_merchant, name_merchant_category
ORDER BY count DESC
LIMIT 5;

SELECT * FROM small_transactions_top_5_merchant;
/* While there were a few merchants had a relatively higher number of small transactions, they did not appear to be excessive and thus not enough evidence to suggest a
credit card had been hacked. */