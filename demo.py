from flask import Flask, render_template, request, redirect, url_for, session
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

@app.route('/logout')
def logout():
    session.pop('username', None)
    return redirect(url_for('home'))

if __name__ == '__main__':
    app.run(debug=True)