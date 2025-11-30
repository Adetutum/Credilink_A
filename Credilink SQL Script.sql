CREATE DATABASE Credilink;
use Credilink_db;
##trying to understand my cleaned dataset
SELECT 
    *
FROM
    final_cleaned_credilink_data;
SELECT DISTINCT
    housing
FROM
    fintech_user;
    
SELECT 
    user,
    age,
    housing, credit_score, zodiac_sign,
    registered_phones, payment_type, is_referred
    from final_cleaned_credilink_data;

SELECT DISTINCT
    user
FROM
    final_cleaned_credilink_data;
    
SELECT 
    user, age
FROM
    final_cleaned_credilink_data
ORDER BY user;

SELECT
        user,
        age,
        housing,
        credit_score,
        zodiac_sign,
        registered_phones,
        payment_type,
        is_referred,
        ROW_NUMBER() OVER (
            PARTITION BY t1.user 
            ORDER BY age DESC, credit_score DESC 
        ) as rn
    FROM 
        final_cleaned_credilink_data t1;

SELECT 
    user,
    MAX(age) AS definitive_age,
    MAX(credit_score) AS highest_credit_score,
    MAX(registered_phones) AS max_registered_phones,
    ANY_VALUE(housing) AS housing,
    ANY_VALUE(zodiac_sign) AS zodiac_sign,
    ANY_VALUE(payment_type) AS payment_type,
    ANY_VALUE(is_referred) AS is_referred
FROM
    final_cleaned_credilink_data
GROUP BY user;

##Creating  SQL tables for Users, Transactions, Loans, and Engagement. 

drop table if exists users;
CREATE TABLE users (
    user_id VARCHAR(255) PRIMARY KEY,
    age DOUBLE,
    housing TEXT,
    credit_score TEXT,
    zodiac_sign TEXT,
    registered_phones INT,
    payment_type TEXT,
    is_referred INT
);
SELECT 
    *
FROM
    users;
INSERT INTO users ( 
    user_id, 
    age, 
    housing, 
    credit_score, 
    zodiac_sign, 
    registered_phones, 
    payment_type, 
    is_referred 
) 
SELECT  
    t1.user, 
    MAX(t1.age) AS definitive_age,
	ANY_VALUE(t1.housing) AS housing,
    MAX(t1.credit_score) AS highest_credit_score,
    ANY_VALUE(t1.zodiac_sign) AS zodiac_sign, 
    MAX(t1.registered_phones) AS max_registered_phones,
    ANY_VALUE(t1.payment_type) AS payment_type, 
    ANY_VALUE(t1.is_referred) AS is_referred
FROM 
    final_cleaned_credilink_data t1
GROUP BY 
    t1.user;

drop tables if exists transactions;
CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(255),
    deposits BIGINT,
    withdrawal BIGINT,
    purchases_partners BIGINT,
    purchases BIGINT,
    rewards_earned DOUBLE,
    reward_rate DOUBLE,
    FOREIGN KEY (user_id)
        REFERENCES users (user_id)
);
SELECT 
    *
FROM
    transactions;
INSERT INTO transactions (user_id,
    deposits, withdrawal,
    purchases_partners, purchases,
    rewards_earned, reward_rate
)
SELECT
    t1.user, t1.deposits, t1.withdrawal,
    t1.purchases_partners, t1.purchases,
    t1.rewards_earned, t1.reward_rate
FROM final_cleaned_credilink_data t1;

CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(255),
    waiting_4_loan BIGINT,
    cancelled_loan BIGINT,
    received_loan BIGINT,
    rejected_loan BIGINT,
    FOREIGN KEY (user_id)
        REFERENCES users (user_id)
);

INSERT INTO loans (
    user_id, waiting_4_loan, cancelled_loan,
    received_loan, rejected_loan
)
SELECT
    t1.user, t1.waiting_4_loan, t1.cancelled_loan,
    t1.received_loan, t1.rejected_loan
FROM final_cleaned_credilink_data t1;

CREATE TABLE engagement (
    engagement_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(255),
    churn BIGINT,
    cc_taken BIGINT,
    cc_recommended BIGINT,
    cc_disliked BIGINT,
    cc_liked BIGINT,
    cc_application_begin BIGINT,
    app_downloaded BIGINT,
    web_user BIGINT,
    app_web_user BIGINT,
    ios_user BIGINT,
    android_user BIGINT,
    left_for_two_month_plus BIGINT,
    left_for_one_month BIGINT,
    FOREIGN KEY (user_id)
        REFERENCES users (user_id)
);

INSERT INTO engagement (
    user_id, churn,
    cc_taken, cc_recommended, cc_disliked, cc_liked,
    cc_application_begin,
    app_downloaded, web_user, app_web_user,
    ios_user, android_user,
    left_for_two_month_plus, left_for_one_month
)
SELECT
    t1.user, t1.churn,
    t1.cc_taken, t1.cc_recommended, t1.cc_disliked, t1.cc_liked,
    t1.cc_application_begin,
    t1.app_downloaded, t1.web_user, t1.app_web_user,
    t1.ios_user, t1.android_user,
    t1.left_for_two_month_plus, t1.left_for_one_month
FROM final_cleaned_credilink_data t1;

SELECT 
    *
FROM
    final_cleaned_credilink_data;
SELECT 
    *
FROM
    users;
SELECT 
    *
FROM
    transactions;
SELECT 
    *
FROM
    engagement;
SELECT 
    *
FROM
    loans;
drop table loans;    
##Note; if a transaction date was provided, the code below would calculate the daily and monthly active users
##daily active users
SELECT
    DATE(stra) AS activity_date,
    COUNT(DISTINCT user_id) AS DAU_Count
FROM
    transactions
GROUP BY
    activity_date
ORDER BY
    activity_date;
