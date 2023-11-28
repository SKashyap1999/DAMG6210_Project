/*View reported messages made by users across listings*/
CREATE VIEW reported_message_view AS
SELECT
  i.Item_ID as item_id,
  i.Item_Name as item_name,
  m.content,
  s1.First_Name as Sender_Name,
  s2.First_Name as Receiver_Name
FROM
  MESSAGE_REPORT as mr
JOIN
  REPORT as r on mr.Report_ID = r.Report_ID
JOIN
  MESSAGE as m ON mr.Message_ID = m.Message_ID
JOIN
  ITEM as i on m.Listing_ID = i.Item_ID
JOIN
  STUDENT as s1 on s1.Student_id = m.Sender_Student_ID
JOIN
  STUDENT as s2 on s2.Student_id = m.Receiver_Student_ID;




/* View reviews on items added to cart / saved item */
CREATE VIEW saved_item_reviews_view AS
SELECT
t.item_id as item_id,
t.item_name as item_name,
r.Comment as comment,
r.Rating as rating
FROM (SELECT i.Item_ID as item_id,
           i.Item_Name as item_name
    FROM SAVED_ITEM as saved,
        ITEM as i WHERE saved.Item_ID=i.Item_ID) as t JOIN REVIEW as r on t.item_id=r.Listing_ID;








/* Recently Posted Items */
CREATE VIEW recently_posted_items_view AS
SELECT TOP 25 PERCENT
  l.Listing_ID,
  l.Date_Posted,
  i.Item_Name,
  c.Category_Name,
  l.Location
FROM
  LISTING l
JOIN
  ITEM i ON l.Listing_ID = i.Item_ID
JOIN
  CATEGORY c ON i.Item_Category = c.Category_ID
ORDER BY
  l.Date_Posted DESC;


SELECT * from recently_posted_items_view;




/* Number Items sold by the Seller */
CREATE VIEW items_by_seller_view AS
SELECT
  l.Listing_Seller_ID as Seller_ID,
  COUNT(l.Listing_ID) as Total_Items
FROM
  LISTING l
GROUP BY
  l.Listing_Seller_ID;




/*Average Item Price by Category*/
CREATE VIEW avg_item_price_by_category_view AS
SELECT
  c.Category_Name,
  AVG(i.Item_Price) as Avg_Price
FROM
  ITEM i
JOIN
  CATEGORY c ON i.Item_Category = c.Category_ID
GROUP BY
  c.Category_Name;


select * from avg_item_price_by_category_view;


/* Active Sellers */
CREATE VIEW active_sellers_view AS
SELECT
  l.Listing_Seller_ID as Seller_ID,
  COUNT(DISTINCT l.Listing_ID) as Total_Active_Listings
FROM
  LISTING l
WHERE
  l.IsLive = 'TRUE'
GROUP BY
  l.Listing_Seller_ID;
