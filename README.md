# Art Gallery Management System - Complete Web Application

A comprehensive database management system for art galleries with auctions, built with Flask and MySQL.

## Features

### Core Functionality
- **Dashboard**: Overview with statistics and quick actions
- **Artist Management**: Full CRUD operations for artists
- **Artwork Management**: Manage artworks with artist associations
- **Auction System**: Create and manage auctions with bidding functionality
- **Buyer Management**: Track buyers and their purchase history
- **Exhibition Management**: Organize and manage exhibitions
- **Reports & Analytics**: View insights and statistics

### Advanced Features
- **Stored Procedures**: `place_bid`, `finalize_auction`, `process_payment`
- **Views**: 
  - `artwork_details`: Artworks with artist info and exhibition count
  - `auction_statistics`: Auction stats with bids and artworks
  - `buyer_purchase_history`: Buyer activity and spending
- **Search Functionality**: Real-time search across all data tables
- **Responsive Design**: Works on desktop, tablet, and mobile devices

## Technology Stack

- **Backend**: Python Flask
- **Database**: MySQL 8.0
- **Frontend**: HTML5, CSS3, JavaScript
- **Icons**: Font Awesome 6.4.0

## Installation & Setup

### Prerequisites
- Python 3.8 or higher
- MySQL 8.0 or higher
- pip (Python package manager)

### Step 1: Database Setup

1. Start your MySQL server

2. Import the database dump:
```bash
mysql -u root -p < Dump20251017.sql
```

This will create the `artgal` database with all tables, views, procedures, and sample data.

### Step 2: Configure Database Connection

1. Open `app.py` in a text editor

2. Update the database configuration (around line 11):
```python
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': 'YOUR_MYSQL_PASSWORD',  # Change this!
    'database': 'artgal'
}
```

3. Replace `'YOUR_MYSQL_PASSWORD'` with your actual MySQL root password

### Step 3: Install Python Dependencies

```bash
# Navigate to the project directory
cd art-gallery-app

# Install required packages
pip install -r requirements.txt
```

### Step 4: Run the Application

```bash
python app.py
```

The application will start on `http://localhost:5000`

## Usage Guide

### 1. Dashboard
- View statistics for all entities (artworks, artists, auctions, etc.)
- Quick access to common actions
- Navigate using the top navigation bar

### 2. Managing Artists
- **Add**: Click "Add Artist" button, fill in details
- **Edit**: Click edit icon next to artist in the list
- **Delete**: Click delete icon (confirmation required)
- **Search**: Use search box to filter artists

### 3. Managing Artworks
- **Add**: Select artist from dropdown, enter artwork details
- **Edit**: Update artwork information
- **Delete**: Remove artworks from system
- **View**: See all artworks with artist names and prices

### 4. Auction System

#### Creating an Auction:
1. Click "Create Auction" button
2. Enter date, location, and status
3. Submit the form

#### Viewing Auction Details:
1. Click "View Details" on any auction card
2. See all artworks in the auction
3. View all placed bids

#### Placing a Bid:
1. Go to auction detail page
2. Click "Place Bid" on desired artwork
3. Enter your buyer ID and bid amount
4. Submit (stored procedure validates bid)

#### Finalizing an Auction:
1. Click "Finalize Auction" button
2. System automatically determines winners (highest bids)
3. Updates auction status to "Completed"

### 5. Buyers
- View all registered buyers
- See purchase history and statistics
- Add new buyers to the system

### 6. Exhibitions
- Create new exhibitions with themes
- Set start and end dates
- View all exhibitions

### 7. Reports
- Top artworks by price
- Artist statistics (artwork count, average price)
- Upcoming auctions

## Database Schema

### Tables
1. **artist**: Artist information
2. **artwork**: Artwork details with creator reference
3. **auction**: Auction events
4. **auction_artwork**: Many-to-many relation
5. **bid**: Bidding records
6. **buyer**: Buyer information
7. **exhibition**: Exhibition details
8. **visitor**: Gallery visitors
9. **attends**: Visitor-exhibition relation
10. **participates_in**: Artwork-exhibition relation
11. **payment**: Payment records

### Views
1. **artwork_details**: Comprehensive artwork information
2. **auction_statistics**: Auction metrics
3. **buyer_purchase_history**: Buyer activity summary

### Stored Procedures
1. **place_bid**: Validates and places bids
2. **finalize_auction**: Determines auction winners
3. **process_payment**: Records payments

## Project Structure

```
art-gallery-app/
├── app.py                 # Main Flask application
├── requirements.txt       # Python dependencies
├── static/
│   ├── css/
│   │   └── style.css     # Complete styling
│   └── js/
│       └── main.js       # Client-side JavaScript
└── templates/
    ├── base.html         # Base template
    ├── index.html        # Dashboard
    ├── artists.html      # Artist listing
    ├── artist_form.html  # Add/Edit artist
    ├── artworks.html     # Artwork listing
    ├── artwork_form.html # Add/Edit artwork
    ├── auctions.html     # Auction listing
    ├── auction_form.html # Create auction
    ├── auction_detail.html # Auction details & bidding
    ├── buyers.html       # Buyer listing
    ├── buyer_form.html   # Add buyer
    ├── exhibitions.html  # Exhibition listing
    ├── exhibition_form.html # Add exhibition
    └── reports.html      # Reports & analytics
```

## Key Features Implementation

### CRUD Operations
All entities support full Create, Read, Update, Delete operations through intuitive forms.

### Stored Procedures
- **place_bid**: Validates minimum bid requirements and prevents lower bids
- **finalize_auction**: Automatically determines winners based on highest bids
- **process_payment**: Records payment transactions

### Views (Complex Queries)
- Join operations across multiple tables
- Aggregate functions (COUNT, AVG, MAX)
- Grouped results for analytics

### Triggers
The database includes triggers for:
- Updating bid timestamps
- Validating business rules
- Maintaining data integrity

## Screenshots for Documentation

When documenting your project, capture screenshots of:
1. Dashboard with statistics
2. Artist listing page
3. Add/Edit artist form
4. Artwork listing with search
5. Auction cards view
6. Auction detail page with bidding modal
7. Bid placement confirmation
8. Buyer purchase history
9. Exhibition listing
10. Reports page with analytics

## API Endpoints

The application includes a REST API endpoint:

```
GET /api/artworks
```

Returns JSON data of all artworks with details.

Example:
```bash
curl http://localhost:5000/api/artworks
```

## Troubleshooting

### Common Issues

1. **Database Connection Error**
   - Verify MySQL is running
   - Check DB_CONFIG credentials in app.py
   - Ensure `artgal` database exists

2. **Import Error**
   - Install dependencies: `pip install -r requirements.txt`

3. **Port Already in Use**
   - Change port in app.py: `app.run(debug=True, port=5001)`

4. **Bid Placement Fails**
   - Ensure buyer_id exists in buyer table
   - Check bid amount >= artwork price
   - Verify auction status is "Upcoming"

## For Your DBMS Project Report

### Include These Sections:

1. **User Requirement Specification**
   - Purpose: Manage art gallery operations including auctions
   - Scope: CRUD operations, auction system, reporting
   - Detailed description with entities

2. **ER Diagram**
   - Create using the database schema
   - Show all entities and relationships

3. **Relational Schema**
   - Normalize to 3NF
   - Document all tables with attributes

4. **DDL Commands**
   - CREATE TABLE statements (from dump file)
   - ALTER TABLE for constraints

5. **CRUD Screenshots**
   - All add/edit/delete operations
   - Include success/error messages

6. **Stored Procedures/Functions**
   - place_bid implementation
   - finalize_auction logic
   - Include code snippets

7. **Complex Queries**
   - View definitions
   - Join operations
   - Aggregate queries

8. **Frontend Screenshots**
   - All pages showing functionality
   - Responsive design on different screens

## License

This project is for educational purposes as part of DBMS Mini Project (UE23CS351A).

## Contributors

[Add your team member names and IDs here]

## Acknowledgments

- PESU Faculty for project guidance
- Flask and MySQL communities for excellent documentation