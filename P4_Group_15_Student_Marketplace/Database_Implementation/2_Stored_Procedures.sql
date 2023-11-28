/*Stored Procedure for getting reviews on a particular LISTING*/
CREATE PROCEDURE GetReviewsonItem
    @ListingID VARCHAR(100)
AS
BEGIN
    SELECT
        I.Item_Name,
        L.Listing_ID,
        L.Date_Posted AS Listing_Date,
        R.Rating,
        R.Comment
    FROM
        LISTING L
    JOIN
        ITEM I ON L.Listing_ID = I.Item_ID
    LEFT JOIN
        REVIEW R ON I.Item_ID = R.Listing_ID
    WHERE
        L.Listing_ID = 'A01';
END;

EXEC GetReviewsonItem @ListingID = 'A01';

select * from review;

/*Stored Procedure for Add to Cart / Save an Item from the Live Listings */
CREATE PROCEDURE AddtoCart @student_id INTEGER, @listing_id VARCHAR(100)
AS 
BEGIN
IF(EXISTS(SELECT * FROM LISTING WHERE LISTING.Listing_ID = @listing_id AND LISTING.IsLive = 'TRUE'))
BEGIN
INSERT INTO SAVED_ITEM VALUES(@student_id,@listing_id,'Y',GETDATE())
END;
ELSE
BEGIN
SELECT 'Cannot serve request' as Failure
END;
END;

EXEC AddtoCart @student_id = '2', @listing_id = 'F23';

select * from SAVED_ITEM WHERE Student_ID = '2' AND Item_ID = 'F23';

/*Stored Procedure for getting avg, +ve review count, -ve review count, 
neutral review count and total review count for a user with listings*/

CREATE PROCEDURE GetSellerStats @user_id INTEGER,
@avg_rating DECIMAL(10,2) OUTPUT,
@pos_review INTEGER OUTPUT,
@neg_review INTEGER OUTPUT,
@neu_review INTEGER OUTPUT,
@total_review INTEGER OUTPUT AS

BEGIN
CREATE TABLE t(
rating DECIMAL NOT NULL,
range_review VARCHAR(20) NOT NULL
)
INSERT INTO t(rating,range_review) 
(SELECT r.Rating as rating, CASE
           WHEN r.Rating >=8 THEN 'GOOD' 
           WHEN r.Rating >= 5 THEN 'AVERAGE'
           ELSE 'BAD' END as range_review FROM REVIEW as r JOIN LISTING as l on r.Listing_ID=l.Listing_ID  WHERE l.Listing_Seller_ID=@user_id);
SELECT @avg_rating=AVG(rating) FROM t;
SELECT @pos_review=COUNT(*) FROM t WHERE range_review LIKE 'GOOD';
SELECT @neu_review=COUNT(*) FROM t WHERE range_review LIKE 'AVERAGE';
SELECT @neg_review=COUNT(*) FROM t WHERE range_review LIKE 'BAD';
SELECT @total_review=COUNT(*) FROM t;
DROP TABLE t;
END;

DECLARE 
    @user_id INTEGER,
    @avg_rating DECIMAL(10,2),
    @pos_review INTEGER,
    @neg_review INTEGER,
    @neu_review INTEGER,
    @total_review INTEGER;
 
SET @user_id = 117;
EXEC GetSellerStats 
    @user_id = @user_id,
    @avg_rating = @avg_rating OUTPUT,
    @pos_review = @pos_review OUTPUT,
    @neg_review = @neg_review OUTPUT,
    @neu_review = @neu_review OUTPUT,
    @total_review = @total_review OUTPUT;
 
PRINT 'Average Rating: ' + CONVERT(VARCHAR(10), @avg_rating);
PRINT 'Positive Reviews: ' + CONVERT(VARCHAR(10), @pos_review);
PRINT 'Negative Reviews: ' + CONVERT(VARCHAR(10), @neg_review);
PRINT 'Neutral Reviews: ' + CONVERT(VARCHAR(10), @neu_review);
PRINT 'Total Reviews: ' + CONVERT(VARCHAR(10), @total_review);
