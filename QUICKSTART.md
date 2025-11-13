# Quick Start Guide - Art Gallery Management System


### 1. Import Database (1 minute)
```bash
mysql -u root -p < Dump20251017.sql
```
Enter your MySQL password when prompted.

### 2. Configure App (30 seconds)
Open `app.py` and change line 14:
```python
'password': 'your_actual_mysql_password',
```

### 3. Install Dependencies (1 minute)
```bash
pip install Flask mysql-connector-python
```

### 4. Run Application (30 seconds)
```bash
python app.py
```

### 5. Open Browser (30 seconds)
Go to: http://localhost:5000

## ✅ Verify Setup

1. **Dashboard loads** - You should see 6 statistic cards
2. **Artists page** - Should show 4 sample artists
3. **Artworks page** - Should show 5 sample artworks
4. **Auctions page** - Should show 3 sample auctions

## 🎯 Quick Test

### Test CRUD Operations:
1. Add a new artist (Artists → Add Artist)
2. Add a new artwork (Artworks → Add Artwork)
3. Create an auction (Auctions → Create Auction)
4. Place a bid (Auctions → View Details → Place Bid)

### Test Stored Procedures:
1. Go to any auction detail page
2. Click "Place Bid" on an artwork
3. Enter buyer_id: 1, amount: 60000
4. Submit and verify success message

### Test Views:
1. Go to Reports page
2. Verify data shows in all sections

## 🛠️ Common Commands

### View all buyers:
```sql
SELECT * FROM buyer_purchase_history;
```

### View auction statistics:
```sql
SELECT * FROM auction_statistics;
```

### View artwork details:
```sql
SELECT * FROM artwork_details;
```

### Manually place a bid (if needed):
```sql
CALL place_bid(1, 1, 1, 55000.00);
```

## 📊 Sample Data Overview

- **4 Artists**: Van Gogh, Picasso, da Vinci, Kahlo
- **5 Artworks**: Starry Night, Guernica, Mona Lisa, etc.
- **3 Auctions**: New York, London, Paris
- **3 Buyers**: Sample buyers for testing

## 🐛 Quick Fixes

**Can't connect to database?**
- Check MySQL is running: `mysql -u root -p`
- Verify password in app.py

**Page won't load?**
- Check terminal for errors
- Verify port 5000 is free

**No data showing?**
- Re-import: `mysql -u root -p artgal < Dump20251017.sql`

## Need Help?

1. Check README.md for detailed documentation
2. Review error messages in terminal
3. Verify MySQL connection: `mysql -u root -p artgal`

---

## Next Steps

Once setup is complete:
1. ✅ Test all CRUD operations
2. ✅ Test bidding system
3. ✅ Explore reports
4. ✅ Take screenshots
5. ✅ Document your work

