from flask import Flask, render_template, request, redirect, url_for, flash, jsonify
import mysql.connector
from mysql.connector import Error
from datetime import datetime
import os

app = Flask(__name__)
app.secret_key = 'your-secret-key-here-change-this'

# Database configuration
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': 'parineetha',  # Change this
    'database': 'artgal'
}

def get_db_connection():
    """Create and return a database connection"""
    try:
        connection = mysql.connector.connect(**DB_CONFIG)
        return connection
    except Error as e:
        print(f"Error connecting to database: {e}")
        return None

# ==================== HOME & DASHBOARD ====================
@app.route('/')
def index():
    """Home page with dashboard statistics"""
    conn = get_db_connection()
    if not conn:
        flash('Database connection failed', 'error')
        return render_template('index.html', stats={})
    
    cursor = conn.cursor(dictionary=True)
    stats = {}
    
    try:
        # Get statistics
        cursor.execute("SELECT COUNT(*) as count FROM artwork")
        stats['total_artworks'] = cursor.fetchone()['count']
        
        cursor.execute("SELECT COUNT(*) as count FROM artist")
        stats['total_artists'] = cursor.fetchone()['count']
        
        cursor.execute("SELECT COUNT(*) as count FROM auction")
        stats['total_auctions'] = cursor.fetchone()['count']
        
        cursor.execute("SELECT COUNT(*) as count FROM buyer")
        stats['total_buyers'] = cursor.fetchone()['count']
        
        cursor.execute("SELECT COUNT(*) as count FROM visitor")
        stats['total_visitors'] = cursor.fetchone()['count']
        
        cursor.execute("SELECT COUNT(*) as count FROM exhibition")
        stats['total_exhibitions'] = cursor.fetchone()['count']
        
    except Error as e:
        print(f"Error fetching stats: {e}")
        flash('Error loading statistics', 'error')
    finally:
        cursor.close()
        conn.close()
    
    return render_template('index.html', stats=stats)

# ==================== ARTIST CRUD ====================
@app.route('/artists')
def artists():
    """List all artists"""
    conn = get_db_connection()
    if not conn:
        flash('Database connection failed', 'error')
        return render_template('artists.html', artists=[])
    
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute("SELECT * FROM artist ORDER BY artist_id")
        artists = cursor.fetchall()
    except Error as e:
        print(f"Error fetching artists: {e}")
        artists = []
        flash('Error loading artists', 'error')
    finally:
        cursor.close()
        conn.close()
    
    return render_template('artists.html', artists=artists)

@app.route('/artists/add', methods=['GET', 'POST'])
def add_artist():
    """Add a new artist"""
    if request.method == 'POST':
        artist_id = request.form.get('artist_id')
        name = request.form.get('name')
        bio = request.form.get('bio')
        contact = request.form.get('contact')
        
        conn = get_db_connection()
        if not conn:
            flash('Database connection failed', 'error')
            return redirect(url_for('artists'))
        
        cursor = conn.cursor()
        try:
            cursor.execute(
                "INSERT INTO artist (artist_id, Name, Bio, Contact_info) VALUES (%s, %s, %s, %s)",
                (artist_id, name, bio, contact)
            )
            conn.commit()
            flash('Artist added successfully!', 'success')
        except Error as e:
            print(f"Error adding artist: {e}")
            flash(f'Error adding artist: {str(e)}', 'error')
        finally:
            cursor.close()
            conn.close()
        
        return redirect(url_for('artists'))
    
    return render_template('artist_form.html', artist=None)

@app.route('/artists/edit/<int:artist_id>', methods=['GET', 'POST'])
def edit_artist(artist_id):
    """Edit an existing artist"""
    conn = get_db_connection()
    if not conn:
        flash('Database connection failed', 'error')
        return redirect(url_for('artists'))
    
    cursor = conn.cursor(dictionary=True)
    
    if request.method == 'POST':
        name = request.form.get('name')
        bio = request.form.get('bio')
        contact = request.form.get('contact')
        
        try:
            cursor.execute(
                "UPDATE artist SET Name=%s, Bio=%s, Contact_info=%s WHERE artist_id=%s",
                (name, bio, contact, artist_id)
            )
            conn.commit()
            flash('Artist updated successfully!', 'success')
        except Error as e:
            print(f"Error updating artist: {e}")
            flash(f'Error updating artist: {str(e)}', 'error')
        finally:
            cursor.close()
            conn.close()
        
        return redirect(url_for('artists'))
    
    try:
        cursor.execute("SELECT * FROM artist WHERE artist_id=%s", (artist_id,))
        artist = cursor.fetchone()
    except Error as e:
        print(f"Error fetching artist: {e}")
        artist = None
        flash('Error loading artist', 'error')
    finally:
        cursor.close()
        conn.close()
    
    return render_template('artist_form.html', artist=artist)

@app.route('/artists/delete/<int:artist_id>', methods=['POST'])
def delete_artist(artist_id):
    """Delete an artist"""
    conn = get_db_connection()
    if not conn:
        flash('Database connection failed', 'error')
        return redirect(url_for('artists'))
    
    cursor = conn.cursor()
    try:
        cursor.execute("DELETE FROM artist WHERE artist_id=%s", (artist_id,))
        conn.commit()
        flash('Artist deleted successfully!', 'success')
    except Error as e:
        print(f"Error deleting artist: {e}")
        flash(f'Error deleting artist: {str(e)}', 'error')
    finally:
        cursor.close()
        conn.close()
    
    return redirect(url_for('artists'))

# ==================== ARTWORK CRUD ====================
@app.route('/artworks')
def artworks():
    """List all artworks with artist details"""
    conn = get_db_connection()
    if not conn:
        flash('Database connection failed', 'error')
        return render_template('artworks.html', artworks=[])
    
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT a.*, ar.Name as artist_name 
            FROM artwork a 
            LEFT JOIN artist ar ON a.creator_id = ar.artist_id 
            ORDER BY a.artwork_id
        """)
        artworks = cursor.fetchall()
    except Error as e:
        print(f"Error fetching artworks: {e}")
        artworks = []
        flash('Error loading artworks', 'error')
    finally:
        cursor.close()
        conn.close()
    
    return render_template('artworks.html', artworks=artworks)

@app.route('/artworks/add', methods=['GET', 'POST'])
def add_artwork():
    """Add a new artwork"""
    conn = get_db_connection()
    if not conn:
        flash('Database connection failed', 'error')
        return redirect(url_for('artworks'))
    
    cursor = conn.cursor(dictionary=True)
    
    if request.method == 'POST':
        artwork_id = request.form.get('artwork_id')
        title = request.form.get('title')
        art_type = request.form.get('type')
        creation_yr = request.form.get('creation_yr')
        price = request.form.get('price')
        creator_id = request.form.get('creator_id')
        
        try:
            cursor.execute(
                "INSERT INTO artwork (artwork_id, Title, Type, creation_yr, price, creator_id) VALUES (%s, %s, %s, %s, %s, %s)",
                (artwork_id, title, art_type, creation_yr, price, creator_id)
            )
            conn.commit()
            flash('Artwork added successfully!', 'success')
        except Error as e:
            print(f"Error adding artwork: {e}")
            flash(f'Error adding artwork: {str(e)}', 'error')
        finally:
            cursor.close()
            conn.close()
        
        return redirect(url_for('artworks'))
    
    try:
        cursor.execute("SELECT artist_id, Name FROM artist ORDER BY Name")
        artists = cursor.fetchall()
    except Error as e:
        print(f"Error fetching artists: {e}")
        artists = []
    finally:
        cursor.close()
        conn.close()
    
    return render_template('artwork_form.html', artwork=None, artists=artists)

@app.route('/artworks/edit/<int:artwork_id>', methods=['GET', 'POST'])
def edit_artwork(artwork_id):
    """Edit an existing artwork"""
    conn = get_db_connection()
    if not conn:
        flash('Database connection failed', 'error')
        return redirect(url_for('artworks'))
    
    cursor = conn.cursor(dictionary=True)
    
    if request.method == 'POST':
        title = request.form.get('title')
        art_type = request.form.get('type')
        creation_yr = request.form.get('creation_yr')
        price = request.form.get('price')
        creator_id = request.form.get('creator_id')
        
        try:
            cursor.execute(
                "UPDATE artwork SET Title=%s, Type=%s, creation_yr=%s, price=%s, creator_id=%s WHERE artwork_id=%s",
                (title, art_type, creation_yr, price, creator_id, artwork_id)
            )
            conn.commit()
            flash('Artwork updated successfully!', 'success')
        except Error as e:
            print(f"Error updating artwork: {e}")
            flash(f'Error updating artwork: {str(e)}', 'error')
        finally:
            cursor.close()
            conn.close()
        
        return redirect(url_for('artworks'))
    
    try:
        cursor.execute("SELECT * FROM artwork WHERE artwork_id=%s", (artwork_id,))
        artwork = cursor.fetchone()
        cursor.execute("SELECT artist_id, Name FROM artist ORDER BY Name")
        artists = cursor.fetchall()
    except Error as e:
        print(f"Error fetching data: {e}")
        artwork = None
        artists = []
        flash('Error loading artwork', 'error')
    finally:
        cursor.close()
        conn.close()
    
    return render_template('artwork_form.html', artwork=artwork, artists=artists)

@app.route('/artworks/delete/<int:artwork_id>', methods=['POST'])
def delete_artwork(artwork_id):
    """Delete an artwork"""
    conn = get_db_connection()
    if not conn:
        flash('Database connection failed', 'error')
        return redirect(url_for('artworks'))
    
    cursor = conn.cursor()
    try:
        cursor.execute("DELETE FROM artwork WHERE artwork_id=%s", (artwork_id,))
        conn.commit()
        flash('Artwork deleted successfully!', 'success')
    except Error as e:
        print(f"Error deleting artwork: {e}")
        flash(f'Error deleting artwork: {str(e)}', 'error')
    finally:
        cursor.close()
        conn.close()
    
    return redirect(url_for('artworks'))

# ==================== AUCTION MANAGEMENT ====================
@app.route('/auctions')
def auctions():
    """List all auctions with statistics"""
    conn = get_db_connection()
    if not conn:
        flash('Database connection failed', 'error')
        return render_template('auctions.html', auctions=[])
    
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute("SELECT * FROM auction_statistics ORDER BY auction_date")
        auctions = cursor.fetchall()
    except Error as e:
        print(f"Error fetching auctions: {e}")
        auctions = []
        flash('Error loading auctions', 'error')
    finally:
        cursor.close()
        conn.close()
    
    return render_template('auctions.html', auctions=auctions)

@app.route('/auctions/add', methods=['GET', 'POST'])
def add_auction():
    """Add a new auction"""
    if request.method == 'POST':
        auction_date = request.form.get('auction_date')
        location = request.form.get('location')
        status = request.form.get('status')
        
        conn = get_db_connection()
        if not conn:
            flash('Database connection failed', 'error')
            return redirect(url_for('auctions'))
        
        cursor = conn.cursor()
        try:
            cursor.execute(
                "INSERT INTO auction (auction_date, location, status) VALUES (%s, %s, %s)",
                (auction_date, location, status)
            )
            conn.commit()
            flash('Auction added successfully!', 'success')
        except Error as e:
            print(f"Error adding auction: {e}")
            flash(f'Error adding auction: {str(e)}', 'error')
        finally:
            cursor.close()
            conn.close()
        
        return redirect(url_for('auctions'))
    
    return render_template('auction_form.html', auction=None)

@app.route('/auctions/<int:auction_id>')
def auction_detail(auction_id):
    """View auction details including artworks and bids"""
    conn = get_db_connection()
    if not conn:
        flash('Database connection failed', 'error')
        return redirect(url_for('auctions'))
    
    cursor = conn.cursor(dictionary=True)
    try:
        # Get auction details
        cursor.execute("SELECT * FROM auction WHERE auction_id=%s", (auction_id,))
        auction = cursor.fetchone()
        
        # Get artworks in this auction
        cursor.execute("""
            SELECT a.*, ar.Name as artist_name
            FROM auction_artwork aa
            JOIN artwork a ON aa.artwork_id = a.artwork_id
            LEFT JOIN artist ar ON a.creator_id = ar.artist_id
            WHERE aa.auction_id = %s
        """, (auction_id,))
        artworks = cursor.fetchall()
        
        # Get bids for this auction
        cursor.execute("""
            SELECT b.*, bu.Name as buyer_name, a.Title as artwork_title
            FROM bid b
            JOIN buyer bu ON b.buyer_id = bu.buyer_id
            JOIN artwork a ON b.artwork_id = a.artwork_id
            WHERE b.auction_id = %s
            ORDER BY b.bid_amount DESC
        """, (auction_id,))
        bids = cursor.fetchall()
        
    except Error as e:
        print(f"Error fetching auction details: {e}")
        auction = None
        artworks = []
        bids = []
        flash('Error loading auction details', 'error')
    finally:
        cursor.close()
        conn.close()
    
    return render_template('auction_detail.html', auction=auction, artworks=artworks, bids=bids)

@app.route('/auctions/finalize/<int:auction_id>', methods=['POST'])
def finalize_auction(auction_id):
    """Finalize an auction using stored procedure"""
    conn = get_db_connection()
    if not conn:
        flash('Database connection failed', 'error')
        return redirect(url_for('auctions'))
    
    cursor = conn.cursor()
    try:
        cursor.callproc('finalize_auction', [auction_id])
        conn.commit()
        flash('Auction finalized successfully!', 'success')
    except Error as e:
        print(f"Error finalizing auction: {e}")
        flash(f'Error finalizing auction: {str(e)}', 'error')
    finally:
        cursor.close()
        conn.close()
    
    return redirect(url_for('auction_detail', auction_id=auction_id))

# ==================== BID MANAGEMENT ====================
@app.route('/bids/place', methods=['POST'])
def place_bid():
    """Place a bid using stored procedure"""
    auction_id = request.form.get('auction_id')
    buyer_id = request.form.get('buyer_id')
    artwork_id = request.form.get('artwork_id')
    bid_amount = request.form.get('bid_amount')
    
    conn = get_db_connection()
    if not conn:
        flash('Database connection failed', 'error')
        return redirect(url_for('auctions'))
    
    cursor = conn.cursor()
    try:
        cursor.callproc('place_bid', [auction_id, buyer_id, artwork_id, bid_amount])
        conn.commit()
        flash('Bid placed successfully!', 'success')
    except Error as e:
        print(f"Error placing bid: {e}")
        flash(f'Error placing bid: {str(e)}', 'error')
    finally:
        cursor.close()
        conn.close()
    
    return redirect(url_for('auction_detail', auction_id=auction_id))

# ==================== BUYER MANAGEMENT ====================
@app.route('/buyers')
def buyers():
    """List all buyers with purchase history"""
    conn = get_db_connection()
    if not conn:
        flash('Database connection failed', 'error')
        return render_template('buyers.html', buyers=[])
    
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute("SELECT * FROM buyer_purchase_history ORDER BY buyer_id")
        buyers = cursor.fetchall()
    except Error as e:
        print(f"Error fetching buyers: {e}")
        buyers = []
        flash('Error loading buyers', 'error')
    finally:
        cursor.close()
        conn.close()
    
    return render_template('buyers.html', buyers=buyers)

@app.route('/buyers/add', methods=['GET', 'POST'])
def add_buyer():
    """Add a new buyer"""
    if request.method == 'POST':
        buyer_id = request.form.get('buyer_id')
        name = request.form.get('name')
        email = request.form.get('email')
        phone = request.form.get('phone')
        
        conn = get_db_connection()
        if not conn:
            flash('Database connection failed', 'error')
            return redirect(url_for('buyers'))
        
        cursor = conn.cursor()
        try:
            cursor.execute(
                "INSERT INTO buyer (buyer_id, Name, email, phone) VALUES (%s, %s, %s, %s)",
                (buyer_id, name, email, phone)
            )
            conn.commit()
            flash('Buyer added successfully!', 'success')
        except Error as e:
            print(f"Error adding buyer: {e}")
            flash(f'Error adding buyer: {str(e)}', 'error')
        finally:
            cursor.close()
            conn.close()
        
        return redirect(url_for('buyers'))
    
    return render_template('buyer_form.html', buyer=None)

# ==================== EXHIBITION MANAGEMENT ====================
@app.route('/exhibitions')
def exhibitions():
    """List all exhibitions"""
    conn = get_db_connection()
    if not conn:
        flash('Database connection failed', 'error')
        return render_template('exhibitions.html', exhibitions=[])
    
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute("SELECT * FROM exhibition ORDER BY Start_date DESC")
        exhibitions = cursor.fetchall()
    except Error as e:
        print(f"Error fetching exhibitions: {e}")
        exhibitions = []
        flash('Error loading exhibitions', 'error')
    finally:
        cursor.close()
        conn.close()
    
    return render_template('exhibitions.html', exhibitions=exhibitions)

@app.route('/exhibitions/add', methods=['GET', 'POST'])
def add_exhibition():
    """Add a new exhibition"""
    if request.method == 'POST':
        exhibition_id = request.form.get('exhibition_id')
        name = request.form.get('name')
        start_date = request.form.get('start_date')
        end_date = request.form.get('end_date')
        theme = request.form.get('theme')
        
        conn = get_db_connection()
        if not conn:
            flash('Database connection failed', 'error')
            return redirect(url_for('exhibitions'))
        
        cursor = conn.cursor()
        try:
            cursor.execute(
                "INSERT INTO exhibition (exhibition_id, Name, Start_date, End_date, Theme) VALUES (%s, %s, %s, %s, %s)",
                (exhibition_id, name, start_date, end_date, theme)
            )
            conn.commit()
            flash('Exhibition added successfully!', 'success')
        except Error as e:
            print(f"Error adding exhibition: {e}")
            flash(f'Error adding exhibition: {str(e)}', 'error')
        finally:
            cursor.close()
            conn.close()
        
        return redirect(url_for('exhibitions'))
    
    return render_template('exhibition_form.html', exhibition=None)

# ==================== REPORTS & ANALYTICS ====================
@app.route('/reports')
def reports():
    """View various reports and analytics"""
    conn = get_db_connection()
    if not conn:
        flash('Database connection failed', 'error')
        return render_template('reports.html', data={})
    
    cursor = conn.cursor(dictionary=True)
    data = {}
    
    try:
        # Top artworks by price
        cursor.execute("""
            SELECT a.Title, a.price, ar.Name as artist_name, a.Type
            FROM artwork a
            JOIN artist ar ON a.creator_id = ar.artist_id
            ORDER BY a.price DESC
            LIMIT 10
        """)
        data['top_artworks'] = cursor.fetchall()
        
        # Artist with most artworks
        cursor.execute("""
            SELECT ar.Name, COUNT(*) as artwork_count, AVG(a.price) as avg_price
            FROM artist ar
            LEFT JOIN artwork a ON ar.artist_id = a.creator_id
            GROUP BY ar.artist_id, ar.Name
            ORDER BY artwork_count DESC
        """)
        data['artist_stats'] = cursor.fetchall()
        
        # Upcoming auctions
        cursor.execute("""
            SELECT * FROM auction 
            WHERE status = 'Upcoming' AND auction_date >= CURDATE()
            ORDER BY auction_date
        """)
        data['upcoming_auctions'] = cursor.fetchall()
        
    except Error as e:
        print(f"Error generating reports: {e}")
        flash('Error generating reports', 'error')
    finally:
        cursor.close()
        conn.close()
    
    return render_template('reports.html', data=data)

# ==================== API ENDPOINTS ====================
@app.route('/api/artworks')
def api_artworks():
    """API endpoint to get all artworks as JSON"""
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
    
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute("SELECT * FROM artwork_details")
        artworks = cursor.fetchall()
        return jsonify(artworks)
    except Error as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)