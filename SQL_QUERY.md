# SQL Queries for DBMS Report

This document contains all the SQL queries used in the Art Gallery Management System, organized by category.

## 1. DDL Commands (Data Definition Language)

### Create Table Examples (From your dump.sql)

```sql
-- Artist Table
CREATE TABLE artist (
  artist_id INT NOT NULL,
  Name VARCHAR(255) DEFAULT NULL,
  Bio TEXT,
  Contact_info VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (artist_id)
);

-- Artwork Table with Foreign Key
CREATE TABLE artwork (
  artwork_id INT NOT NULL,
  Title VARCHAR(255) DEFAULT NULL,
  Type VARCHAR(100) DEFAULT NULL,
  creation_yr INT DEFAULT NULL,
  price DECIMAL(12,2) DEFAULT NULL,
  creator_id INT DEFAULT NULL,
  PRIMARY KEY (artwork_id),
  KEY creator_id (creator_id),
  CONSTRAINT artwork_ibfk_1 FOREIGN KEY (creator_id) 
    REFERENCES artist (artist_id)
);

-- Auction Table with Auto-increment
CREATE TABLE auction (
  auction_id INT NOT NULL AUTO_INCREMENT,
  auction_date DATE DEFAULT NULL,
  location VARCHAR(511) DEFAULT NULL,
  status VARCHAR(100) DEFAULT NULL,
  PRIMARY KEY (auction_id)
);

-- Bid Table with Multiple Foreign Keys
CREATE TABLE bid (
  bid_id INT NOT NULL AUTO_INCREMENT,
  auction_id INT DEFAULT NULL,
  buyer_id INT DEFAULT NULL,
  artwork_id INT DEFAULT NULL,
  bid_amount DECIMAL(12,2) DEFAULT NULL,
  bid_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  is_winner TINYINT(1) DEFAULT 0,
  PRIMARY KEY (bid_id),
  KEY auction_id (auction_id),
  KEY buyer_id (buyer_id),
  KEY artwork_id (artwork_id),
  CONSTRAINT bid_ibfk_1 FOREIGN KEY (auction_id) 
    REFERENCES auction (auction_id),
  CONSTRAINT bid_ibfk_2 FOREIGN KEY (buyer_id) 
    REFERENCES buyer (buyer_id),
  CONSTRAINT bid_ibfk_3 FOREIGN KEY (artwork_id) 
    REFERENCES artwork (artwork_id)
);
```

## 2. DML Commands (Data Manipulation Language)

### INSERT Operations

```sql
-- Insert Artists
INSERT INTO artist VALUES 
(1, 'Vincent Van Gogh', 'Post-impressionist painter', 'contact@vangogh.com'),
(2, 'Pablo Picasso', 'Founder of Cubism', 'contact@picasso.com'),
(3, 'Leonardo da Vinci', 'Renaissance master', 'contact@davinci.com'),
(4, 'Frida Kahlo', 'Surrealist artist', 'contact@kahlo.com');

-- Insert Artworks
INSERT INTO artwork VALUES 
(1, 'Starry Night', 'Oil Painting', 1889, 50000.00, 1),
(2, 'Guernica', 'Oil Painting', 1937, 75000.00, 2),
(3, 'Mona Lisa', 'Oil Painting', 1503, 100000.00, 3),
(4, 'The Two Fridas', 'Oil Painting', 1943, 60000.00, 4),
(5, 'Sunflowers', 'Oil Painting', 1888, 45000.00, 1);

-- Insert Auctions
INSERT INTO auction VALUES 
(1, '2025-04-10', 'New York Convention Center', 'Upcoming'),
(2, '2025-05-15', 'London Auction House', 'Upcoming'),
(3, '2025-06-20', 'Paris Grand Hall', 'Upcoming');
```

### UPDATE Operations

```sql
-- Update Artist Information
UPDATE artist 
SET Name = 'Vincent Willem van Gogh', 
    Bio = 'Dutch Post-Impressionist painter'
WHERE artist_id = 1;

-- Update Artwork Price
UPDATE artwork 
SET price = 55000.00 
WHERE artwork_id = 1;

-- Update Auction Status
UPDATE auction 
SET status = 'Completed' 
WHERE auction_id = 1;

-- Mark Bid Winner
UPDATE bid 
SET is_winner = 1 
WHERE bid_id = 5;
```

### DELETE Operations

```sql
-- Delete an Artist
DELETE FROM artist WHERE artist_id = 5;

-- Delete an Artwork
DELETE FROM artwork WHERE artwork_id = 10;

-- Delete a Bid
DELETE FROM bid WHERE bid_id = 20;
```

### SELECT Operations

```sql
-- Select All Artists
SELECT * FROM artist ORDER BY artist_id;

-- Select Artworks with Artist Names
SELECT a.*, ar.Name as artist_name 
FROM artwork a 
LEFT JOIN artist ar ON a.creator_id = ar.artist_id 
ORDER BY a.artwork_id;

-- Select Auctions with Status
SELECT * FROM auction 
WHERE status = 'Upcoming' 
ORDER BY auction_date;

-- Count Statistics
SELECT COUNT(*) as total_artworks FROM artwork;
SELECT COUNT(*) as total_artists FROM artist;
SELECT COUNT(*) as total_auctions FROM auction;
```

## 3. Views (Complex Queries)

### View 1: Artwork Details

```sql
CREATE VIEW artwork_details AS
SELECT 
    a.artwork_id,
    a.Title,
    a.Type,
    a.creation_yr,
    a.price,
    ar.Name AS artist_name,
    COUNT(DISTINCT pi.exhibition_id) AS exhibition_count
FROM artwork a
JOIN artist ar ON a.creator_id = ar.artist_id
LEFT JOIN participates_in pi ON a.artwork_id = pi.artwork_id
GROUP BY 
    a.artwork_id, 
    a.Title, 
    a.Type, 
    a.creation_yr, 
    a.price, 
    ar.Name;

-- Using the View
SELECT * FROM artwork_details;
SELECT * FROM artwork_details WHERE price > 50000;
```

### View 2: Auction Statistics

```sql
CREATE VIEW auction_statistics AS
SELECT 
    auc.auction_id,
    auc.auction_date,
    auc.location,
    auc.status,
    COUNT(DISTINCT aa.artwork_id) AS artworks_in_auction,
    COUNT(DISTINCT b.bid_id) AS total_bids,
    ROUND(AVG(b.bid_amount), 2) AS avg_bid_amount,
    MAX(b.bid_amount) AS max_bid_amount
FROM auction auc
LEFT JOIN auction_artwork aa ON auc.auction_id = aa.auction_id
LEFT JOIN bid b ON auc.auction_id = b.auction_id
GROUP BY 
    auc.auction_id, 
    auc.auction_date, 
    auc.location, 
    auc.status;

-- Using the View
SELECT * FROM auction_statistics;
SELECT * FROM auction_statistics WHERE status = 'Upcoming';
```

### View 3: Buyer Purchase History

```sql
CREATE VIEW buyer_purchase_history AS
SELECT 
    b.buyer_id,
    b.Name,
    b.email,
    COUNT(DISTINCT bid.bid_id) AS total_bids,
    COUNT(DISTINCT CASE WHEN bid.is_winner = 1 
          THEN bid.bid_id END) AS winning_bids,
    SUM(CASE WHEN bid.is_winner = 1 
        THEN bid.bid_amount ELSE 0 END) AS total_spent
FROM buyer b
LEFT JOIN bid ON b.buyer_id = bid.buyer_id
GROUP BY b.buyer_id, b.Name, b.email;

-- Using the View
SELECT * FROM buyer_purchase_history;
SELECT * FROM buyer_purchase_history WHERE winning_bids > 0;
```

## 4. Stored Procedures

### Procedure 1: Place Bid

```sql
DELIMITER $$

CREATE PROCEDURE place_bid(
    IN p_auction_id INT,
    IN p_buyer_id INT,
    IN p_artwork_id INT,
    IN p_bid_amount DECIMAL(12,2)
)
BEGIN
    DECLARE v_current_bid DECIMAL(12,2);
    DECLARE v_artwork_price DECIMAL(12,2);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error placing bid';
    END;
    
    -- Get artwork price
    SELECT price INTO v_artwork_price 
    FROM artwork 
    WHERE artwork_id = p_artwork_id;
    
    -- Validate bid amount >= artwork price
    IF p_bid_amount < v_artwork_price THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Bid amount must be >= artwork price';
    END IF;
    
    -- Get current highest bid
    SELECT MAX(bid_amount) INTO v_current_bid 
    FROM bid 
    WHERE artwork_id = p_artwork_id 
    AND auction_id = p_auction_id;
    
    -- Validate bid is higher than current
    IF v_current_bid IS NOT NULL AND p_bid_amount <= v_current_bid THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Bid must be higher than current bid';
    END IF;
    
    -- Place the bid
    START TRANSACTION;
    INSERT INTO bid (auction_id, buyer_id, artwork_id, bid_amount)
    VALUES (p_auction_id, p_buyer_id, p_artwork_id, p_bid_amount);
    COMMIT;
END$$

DELIMITER ;

-- Calling the Procedure
CALL place_bid(1, 1, 1, 55000.00);
```

### Procedure 2: Finalize Auction

```sql
DELIMITER $$

CREATE PROCEDURE finalize_auction(
    IN p_auction_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error finalizing auction';
    END;
    
    START TRANSACTION;
    
    -- Mark winners (highest bid for each artwork)
    UPDATE bid
    SET is_winner = 1
    WHERE bid_id IN (
        SELECT bid_id FROM (
            SELECT b1.bid_id
            FROM bid b1
            WHERE b1.auction_id = p_auction_id
            AND b1.bid_amount = (
                SELECT MAX(b2.bid_amount)
                FROM bid b2
                WHERE b2.artwork_id = b1.artwork_id
                AND b2.auction_id = p_auction_id
            )
        ) AS winner_bids
    );
    
    -- Update auction status
    UPDATE auction 
    SET status = 'Completed' 
    WHERE auction_id = p_auction_id;
    
    COMMIT;
END$$

DELIMITER ;

-- Calling the Procedure
CALL finalize_auction(1);
```

### Procedure 3: Process Payment

```sql
DELIMITER $$

CREATE PROCEDURE process_payment(
    IN p_bid_id INT,
    IN p_method VARCHAR(100)
)
BEGIN
    DECLARE v_bid_amount DECIMAL(12,2);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error processing payment';
    END;
    
    -- Get bid amount
    SELECT bid_amount INTO v_bid_amount 
    FROM bid 
    WHERE bid_id = p_bid_id;
    
    START TRANSACTION;
    
    -- Insert payment record
    INSERT INTO payment (bid_id, amount, method, Process_date, status)
    VALUES (p_bid_id, v_bid_amount, p_method, CURDATE(), 'Completed');
    
    COMMIT;
END$$

DELIMITER ;

-- Calling the Procedure
CALL process_payment(5, 'Credit Card');
```

## 5. Complex Queries (Joins & Aggregates)

### Join Queries

```sql
-- Inner Join: Artworks with Artists
SELECT 
    a.artwork_id,
    a.Title,
    a.Type,
    a.price,
    ar.Name as artist_name,
    ar.Bio as artist_bio
FROM artwork a
INNER JOIN artist ar ON a.creator_id = ar.artist_id;

-- Left Join: Auctions with Artworks
SELECT 
    auc.auction_id,
    auc.auction_date,
    auc.location,
    a.Title as artwork_title,
    a.price
FROM auction auc
LEFT JOIN auction_artwork aa ON auc.auction_id = aa.auction_id
LEFT JOIN artwork a ON aa.artwork_id = a.artwork_id;

-- Multiple Joins: Bids with Full Details
SELECT 
    b.bid_id,
    b.bid_amount,
    b.bid_timestamp,
    bu.Name as buyer_name,
    bu.email as buyer_email,
    a.Title as artwork_title,
    ar.Name as artist_name,
    auc.location as auction_location
FROM bid b
JOIN buyer bu ON b.buyer_id = bu.buyer_id
JOIN artwork a ON b.artwork_id = a.artwork_id
JOIN artist ar ON a.creator_id = ar.artist_id
JOIN auction auc ON b.auction_id = auc.auction_id;
```

### Aggregate Queries

```sql
-- Count artworks by artist
SELECT 
    ar.Name,
    COUNT(a.artwork_id) as artwork_count
FROM artist ar
LEFT JOIN artwork a ON ar.artist_id = a.creator_id
GROUP BY ar.artist_id, ar.Name
ORDER BY artwork_count DESC;

-- Average price by artwork type
SELECT 
    Type,
    COUNT(*) as count,
    AVG(price) as avg_price,
    MIN(price) as min_price,
    MAX(price) as max_price
FROM artwork
GROUP BY Type;

-- Total bids per auction
SELECT 
    auc.auction_id,
    auc.location,
    COUNT(b.bid_id) as total_bids,
    AVG(b.bid_amount) as avg_bid,
    MAX(b.bid_amount) as highest_bid
FROM auction auc
LEFT JOIN bid b ON auc.auction_id = b.auction_id
GROUP BY auc.auction_id, auc.location;

-- Buyer statistics
SELECT 
    bu.Name,
    COUNT(b.bid_id) as total_bids,
    SUM(CASE WHEN b.is_winner = 1 THEN 1 ELSE 0 END) as wins,
    SUM(CASE WHEN b.is_winner = 1 THEN b.bid_amount ELSE 0 END) as total_spent
FROM buyer bu
LEFT JOIN bid b ON bu.buyer_id = b.buyer_id
GROUP BY bu.buyer_id, bu.Name;
```

### Nested Queries (Subqueries)

```sql
-- Artworks more expensive than average
SELECT 
    Title, 
    price,
    Type
FROM artwork
WHERE price > (SELECT AVG(price) FROM artwork);

-- Artists with most expensive artwork
SELECT 
    ar.Name,
    a.Title,
    a.price
FROM artist ar
JOIN artwork a ON ar.artist_id = a.creator_id
WHERE a.price = (
    SELECT MAX(price)
    FROM artwork
    WHERE creator_id = ar.artist_id
);

-- Buyers who haven't won any auction
SELECT 
    bu.Name,
    bu.email
FROM buyer bu
WHERE bu.buyer_id NOT IN (
    SELECT DISTINCT buyer_id
    FROM bid
    WHERE is_winner = 1
);

-- Artworks in upcoming auctions
SELECT 
    a.Title,
    a.price,
    auc.auction_date,
    auc.location
FROM artwork a
WHERE a.artwork_id IN (
    SELECT aa.artwork_id
    FROM auction_artwork aa
    JOIN auction auc ON aa.auction_id = auc.auction_id
    WHERE auc.status = 'Upcoming'
);
```

## 6. Report Queries (Used in Application)

### Top Artworks by Price

```sql
SELECT 
    a.Title, 
    a.price, 
    ar.Name as artist_name, 
    a.Type
FROM artwork a
JOIN artist ar ON a.creator_id = ar.artist_id
ORDER BY a.price DESC
LIMIT 10;
```

### Artist Statistics

```sql
SELECT 
    ar.Name, 
    COUNT(*) as artwork_count, 
    AVG(a.price) as avg_price
FROM artist ar
LEFT JOIN artwork a ON ar.artist_id = a.creator_id
GROUP BY ar.artist_id, ar.Name
ORDER BY artwork_count DESC;
```

### Upcoming Auctions

```sql
SELECT * 
FROM auction 
WHERE status = 'Upcoming' 
AND auction_date >= CURDATE()
ORDER BY auction_date;
```

### Auction Performance

```sql
SELECT 
    auc.auction_id,
    auc.location,
    COUNT(DISTINCT aa.artwork_id) as artworks,
    COUNT(b.bid_id) as total_bids,
    SUM(CASE WHEN b.is_winner = 1 THEN b.bid_amount ELSE 0 END) as revenue
FROM auction auc
LEFT JOIN auction_artwork aa ON auc.auction_id = aa.auction_id
LEFT JOIN bid b ON auc.auction_id = b.auction_id
WHERE auc.status = 'Completed'
GROUP BY auc.auction_id, auc.location;
```

## 7. Triggers (For Reference)

```sql
-- Trigger to update bid timestamp
DELIMITER $$

CREATE TRIGGER before_bid_insert
BEFORE INSERT ON bid
FOR EACH ROW
BEGIN
    SET NEW.bid_timestamp = NOW();
    SET NEW.is_winner = 0;
END$$

DELIMITER ;

-- Trigger to validate artwork price
DELIMITER $$

CREATE TRIGGER before_artwork_insert
BEFORE INSERT ON artwork
FOR EACH ROW
BEGIN
    IF NEW.price < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Price cannot be negative';
    END IF;
END$$

DELIMITER ;
```

## 8. Python Integration (From app.py)

### Query Execution Examples

```python
# Simple SELECT
cursor.execute("SELECT * FROM artist ORDER BY artist_id")
artists = cursor.fetchall()

# Parameterized INSERT
cursor.execute(
    "INSERT INTO artist (artist_id, Name, Bio, Contact_info) VALUES (%s, %s, %s, %s)",
    (artist_id, name, bio, contact)
)
conn.commit()

# Parameterized UPDATE
cursor.execute(
    "UPDATE artwork SET price=%s WHERE artwork_id=%s",
    (new_price, artwork_id)
)
conn.commit()

# Calling Stored Procedure
cursor.callproc('place_bid', [auction_id, buyer_id, artwork_id, bid_amount])
conn.commit()

# Using Views
cursor.execute("SELECT * FROM auction_statistics")
stats = cursor.fetchall()
```

## Summary

This document contains:
- ✅ DDL Commands (CREATE TABLE)
- ✅ DML Commands (INSERT, UPDATE, DELETE, SELECT)
- ✅ View Definitions (3 complex views)
- ✅ Stored Procedures (3 procedures with logic)
- ✅ Complex Queries (Joins, Aggregates, Subqueries)
- ✅ Triggers (Validation and automation)
- ✅ Report Queries (Analytics)
- ✅ Python Integration Examples
