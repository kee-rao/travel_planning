from flask import Flask, render_template, request, redirect, url_for, session,flash
from flask_mysqldb import MySQL

app = Flask(__name__)
app.secret_key = 'bananas'

# MySQL configurations
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'password'
app.config['MYSQL_DB'] = 'travel'

mysql = MySQL(app)

@app.route('/')
def home():
    return render_template('home.html')

def is_userid_taken(user_id):
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM USER WHERE user_id = %s",[user_id])
    user=cur.fetchone()
    cur.close()
    return user is not None

def if_user_exists(user_id,username):
    cur=mysql.connection.cursor()
    cur.execute("SELECT * FROM USER WHERE user_id = %s and username = %s",[user_id,username])
    exists=cur.fetchone()
    cur.close()
    return exists is not None
@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        user_id = request.form['user_id']
        password = request.form['password']
        email = request.form['email']
        phno = request.form['phno']
        if if_user_exists(user_id,username):
            error = "Seems like you have already created an account, please log in"
            return render_template('login.html',error=error)
        if is_userid_taken(user_id):
            error = "This user_id is already taken, please choose another one"
            return render_template('register.html', error=error)
            
        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO USER (username, user_id, email, password, phno) VALUES (%s, %s, %s, %s, %s)",
                    (username,user_id,email, password, phno))
        mysql.connection.commit()
        cur.close()

        return redirect(url_for('login'))
    return render_template('register.html')


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        user_id = request.form['user_id']
        password = request.form['password']

        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM USER WHERE user_id = %s AND password = %s", [user_id, password])
        account = cur.fetchone()
        cur.close()

        if account:
            session['user_id'] = account[1]
            return redirect(url_for('homepage'))
        else:
            error = 'Invalid username or password. Please try again.'
            return render_template('login.html',error=error)

    return render_template('login.html')

@app.route('/homepage')
def homepage():
    if 'user_id' in session:
        # Fetch destinations from database with name, country, popularity, and description
        cur = mysql.connection.cursor()
        cur.execute("SELECT destination_id, Dest_NAME, country, description ,popularity FROM destination ORDER BY popularity DESC LIMIT 6")
        destinations = cur.fetchall()
        cur.close()
        
        return render_template('homepage.html', destinations=destinations)
    
    return redirect(url_for('login'))


@app.route('/destination/<int:destination_id>', methods=['GET', 'POST'])
def destination(destination_id):
    cur = mysql.connection.cursor()
    
    cur.execute("SELECT * FROM DESTINATION WHERE destination_id = %s", [destination_id])
    destination = cur.fetchone()
    
    cur.execute("SELECT * FROM ACCOMMODATION WHERE destination_id = %s", [destination_id])
    accommodations = cur.fetchall()

    flights = []
    if request.method == 'POST':
        departure_date = request.form.get('departure_date')
        return_date = request.form.get('return_date')
        cur.execute("""
            SELECT * FROM FLIGHT 
            WHERE destination_id = %s 
            AND departure_date >= %s 
            AND return_date <= %s
        """, (destination_id, departure_date, return_date))
        flights = cur.fetchall()
    
    cur.close()
    
    return render_template('destination.html', destination=destination, accommodations=accommodations, flights=flights)

@app.route('/book_accommodation/<int:accommodation_id>', methods=['POST'])
def book_accommodation(accommodation_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))

    user_id = session['user_id']
    check_in_date = request.form['check_in_date']
    check_out_date = request.form['check_out_date']
    no_rooms = int(request.form['no_rooms'])
    destination_id = request.form['destination_id']

    cur = mysql.connection.cursor()
    cur.execute("SELECT AVAIL_ROOMS FROM ACCOMMODATION WHERE ACCOMMODATION_ID = %s", [accommodation_id])
    accommodation = cur.fetchone()

    if accommodation and accommodation[0] >= no_rooms:
        cur.execute("""
            INSERT INTO acc_res (ACCOMMODATION_ID, USER_ID, NO_ROOMS, CHECK_IN_DATE, CHECK_OUT_DATE)
            VALUES (%s, %s, %s, %s, %s)
        """, (accommodation_id, user_id, no_rooms, check_in_date, check_out_date))
        mysql.connection.commit()
        cur.close()

        flash("Booking successful!!", "success")
    else:
        cur.close()
        flash("Sorry, all rooms are booked!", "error")

    # Redirect back to the destination details page
    return redirect(url_for('destination', destination_id=destination_id))

@app.route('/book_flight/<int:flight_id>', methods=['POST'])
def book_flight(flight_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))

    user_id = session['user_id']
    no_tickets = int(request.form['no_tickets'])
    destination_id = request.form['destination_id']
    
    cur = mysql.connection.cursor()
    cur.execute("SELECT PRICE, AVAIL_SEATS FROM FLIGHT WHERE FLIGHT_ID = %s", [flight_id])
    flight = cur.fetchone()
    
    if flight and flight[1] >= no_tickets:
        total_price = flight[0] * no_tickets
        cur.execute("""
            INSERT INTO flight_res (Flight_ID, User_ID, no_tickets, TotalPrice)
            VALUES (%s, %s, %s, %s)
        """, (flight_id, user_id, no_tickets, total_price))
        
        # Update the available seats
        cur.execute("""
            UPDATE FLIGHT
            SET AVAIL_SEATS = AVAIL_SEATS - %s
            WHERE FLIGHT_ID = %s
        """, (no_tickets, flight_id))
        
        mysql.connection.commit()
        cur.close()
        
        flash("Flight booking successful!!", "success")
    else:
        cur.close()
        flash("Sorry, there are not enough available seats!", "error")
    
    # Redirect back to the destination details page
    return redirect(url_for('destination', destination_id=destination_id))


@app.route('/logout')
def logout():
    session.pop('username', None)
    return redirect(url_for('home'))

if __name__ == '__main__':
    app.run(debug=True)