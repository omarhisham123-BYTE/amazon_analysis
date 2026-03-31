SELECT *
FROM dbo.amazon
DROP TABLE IF EXISTS products

CREATE TABLE products(
product_id nvarchar(100) PRIMARY KEY  NOT NULL ,
product_name nvarchar(max) NOT NULL ,
actual_price_2 float NOT NULL ,
discounted_price_2 float NOT NULL ,
discount_percentage nvarchar(max) NOT NULL ,
price_after_discount float NOT NULL,
rating float  NULL,
rating_count INT  NULL) ;

WITH CleanData  AS(
SELECT * , ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY (SELECT NULL)) AS ROWNUM
FROM dbo.amazon
)

INSERT INTO products 
(product_id , product_name ,actual_price_2 , discounted_price_2 , discount_percentage , price_after_discount , rating , rating_count)
SELECT DISTINCT product_id , product_name , actual_price_2 , discounted_price_2 , discount_percentage , price_after_discount ,
  rating , rating_count 
FROM CleanData
WHERE ROWNUM = 1
GO
DROP TABLE IF EXISTS Categories
DROP TABLE IF EXISTS product
CREATE TABLE Categories(
category_id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
category_1 NVARCHAR(max) NULL,
category_2 NVARCHAR(max) NULL,
category_3 NVARCHAR(max) NULL,
category_4 NVARCHAR(max) NULL,
category_5 NVARCHAR(max) NULL
);

INSERT INTO Categories (category_1 , category_2 , category_3 , category_4 , category_5 )

SELECT DISTINCT  category_1 , category_2 , category_3 , category_4 , category_5 
FROM dbo.amazon;

DROP TABLE IF EXISTS users
  CREATE TABLE users (
  user_id NVARCHAR(450) PRIMARY KEY ,
  user_name NVARCHAR(max) 
  );

  INSERT INTO users(user_id , user_name)
  SELECT DISTINCT user_id , user_name
  FROM dbo.amazon
  GO

  DROP TABLE IF EXISTS reviews
   CREATE TABLE reviews (
   review_id  INT  PRIMARY KEY IDENTITY(1,1),
   amazon_review_id NVARCHAR(max) ,
   review_title NVARCHAR(max) , 
   review_content NVARCHAR(max),
   product_id NVARCHAR(max) , 
   user_id NVARCHAR(max)
   );
    INSERT INTO reviews (amazon_review_id , review_title , review_content , product_id , user_id)
	SELECT review_id , review_title , review_content , product_id , user_id
	FROM dbo.amazon;


 SELECT SUM(price_after_discount) AS Total_Revenue 
 FROM products p; 

 SELECT COUNT(review_id) AS Total_sales
 FROM reviews r

 SELECT CAST(SUM(p.price_after_discount)AS DECIMAL) / CAST(COUNT(r.review_id) AS DECIMAL) AS avg_revenue_for_order
 FROM products p
 INNER JOIN reviews r
 ON p.product_id = r.product_id

 SELECT TOP 5 p.product_name , COUNT(r.review_id) AS Total_sales
 FROM products p 
 INNER JOIN reviews r
 ON p.product_id = r.product_id
 GROUP BY p.product_name
  
  SELECT TOP 5 user_name , COUNT(r.review_id) AS Total_orders
  FROM users u 
  JOIN reviews r ON r.user_id = u.user_id
  GROUP BY u.user_id, u.user_name
  ORDER BY Total_orders DESC ;


 
