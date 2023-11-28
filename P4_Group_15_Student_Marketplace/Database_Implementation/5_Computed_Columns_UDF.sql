/*Calculate Age of a Student */
ALTER TABLE STUDENT
ADD Age AS dbo.CalculateAge(Date_of_Birth);

SELECT * FROM marketplace.dbo.STUDENT;

CREATE FUNCTION CalculateAge (@DOB DATE)
RETURNS INT
AS
BEGIN
    DECLARE @Age INT
    SELECT @Age = DATEDIFF(YEAR, @DOB, GETDATE())
    RETURN @Age
END;

SELECT * FROM STUDENT;

/*Calculate Discount Percentage on each ITEM */


CREATE FUNCTION dbo.CalculateDiscount (@ItemPrice DECIMAL(18, 2), @SellingPrice DECIMAL(18, 2))
RETURNS DECIMAL(18)
AS
BEGIN
    DECLARE @Discount DECIMAL(18);

    -- Calculate discount percentage
    IF @ItemPrice > 0
        SET @Discount = ((@ItemPrice - @SellingPrice) / @ItemPrice) * 100;
    ELSE
        SET @Discount = 0;

    RETURN @Discount;
END;


ALTER TABLE ITEM
ADD DiscountPercentage AS dbo.CalculateDiscount(Item_Price, Selling_Price);

SELECT * FROM ITEM;