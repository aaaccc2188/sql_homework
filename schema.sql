-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE card_holder (
    id_card_holder INT   NOT NULL,
    name_card_holder VARCHAR(100)   NOT NULL,
    CONSTRAINT pk_card_holder PRIMARY KEY (
        id_card_holder
     )
);

CREATE TABLE credit_card (
    card_number VARCHAR(20)   NOT NULL,
    id_card_holder INT   NOT NULL,
    CONSTRAINT pk_credit_card PRIMARY KEY (
        card_number
     )
);

CREATE TABLE merchant_category (
    id_merchant_category INT   NOT NULL,
    name_merchant_category VARCHAR(50)   NOT NULL,
    CONSTRAINT pk_merchant_category PRIMARY KEY (
        id_merchant_category
     )
);

CREATE TABLE merchants (
    id_merchant INT   NOT NULL,
    name_merchant VARCHAR(200)   NOT NULL,
    id_merchant_category INT   NOT NULL,
    CONSTRAINT pk_merchants PRIMARY KEY (
        id_merchant
     )
);

CREATE TABLE transaction (
    id_transaction INT   NOT NULL,
    date TIMESTAMP   NOT NULL,
    amount FLOAT   NOT NULL,
    card_number VARCHAR(20)   NOT NULL,
    id_merchant INT   NOT NULL,
    CONSTRAINT pk_transaction PRIMARY KEY (
        id_transaction
     )
);

ALTER TABLE credit_card ADD CONSTRAINT fk_credit_card_id_card_holder FOREIGN KEY(id_card_holder)
REFERENCES card_holder (id_card_holder);

ALTER TABLE merchants ADD CONSTRAINT fk_merchants_id_merchant_category FOREIGN KEY(id_merchant_category)
REFERENCES merchant_category (id_merchant_category);

ALTER TABLE transaction ADD CONSTRAINT fk_transaction_card_number FOREIGN KEY(card_number)
REFERENCES credit_card (card_number);

ALTER TABLE transaction ADD CONSTRAINT fk_transaction_id_merchant FOREIGN KEY(id_merchant)
REFERENCES merchants (id_merchant);

CREATE TABLE transaction_by_cardholder AS
	SELECT id_transaction, date, amount, transaction.id_merchant, merchants.id_merchant_category, merchants.name_merchant, merchant_category.name_merchant_category, transaction.card_number, card_holder.id_card_holder, name_card_holder
	FROM transaction
	JOIN credit_card ON credit_card.card_number = transaction.card_number
	JOIN card_holder ON card_holder.id_card_holder = credit_card.id_card_holder
	JOIN merchants ON transaction.id_merchant = merchants.id_merchant
	JOIN merchant_category ON merchant_category.id_merchant_category = merchants.id_merchant_category;