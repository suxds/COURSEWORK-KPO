from flask import Flask, render_template, request, jsonify, redirect, session, url_for
import secrets
import psycopg2
from datetime import datetime, timezone

app = Flask(__name__)
app.secret_key = 'my_secret_key'

def connect_db():
    return psycopg2.connect(
        database="software_engineering_coursework",
        user="postgres",
        password="db2324",
        host="localhost",
        port="5432"
    )

class Meeting:
    def __init__(self, name, group_id, date_time=None):
        self.id = None
        self.name = name
        self.group_id = group_id
        self.date_time = date_time
        self.votes = []

    @classmethod
    def create_meeting(cls, name, group_id, date_time):
        with connect_db() as conn:
            with conn.cursor() as cur:
                cur.execute("INSERT INTO meetings (name, group_id, date_time) VALUES (%s, %s, %s) RETURNING id",
                            (name, group_id, date_time))
                meeting_id = cur.fetchone()[0]

        meeting = cls(name, group_id, date_time)
        meeting.id = meeting_id
        return meeting

class Group:
    def __init__(self, name, password, group_type):
        self.id = None
        self.name = name
        self.password = password
        self.group_type = group_type
        self.meetings = []
    
@app.route('/create_meeting/<int:group_id>', methods=['POST'])
def create_meeting(group_id):
    with connect_db() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM groups WHERE id = %s", (group_id,))
            group_data = cur.fetchone()

            if group_data:
                group_ = Group(name=group_data[1], password=group_data[2], group_type=group_data[3])
                group_.id = group_data[0]

                meeting_name = request.form.get('meeting_name')

                meeting_datetime_str = request.form.get('meeting_datetime')
                print(meeting_datetime_str)
                if meeting_datetime_str:
                    meeting_datetime = datetime.strptime(meeting_datetime_str, '%Y-%m-%dT%H:%M')
                else:
                    meeting_datetime = datetime.now(timezone.utc)

                Meeting.create_meeting(meeting_name, group_id, date_time=meeting_datetime)

                print(f"Meeting created: {meeting_name} for group {group_id} at {meeting_datetime}")
                    
                cur.execute("SELECT * FROM meetings WHERE group_id = %s", (group_.id,))
                group_meetings_ = cur.fetchall()                 
                
                cur.execute("SELECT login FROM users WHERE id IN (SELECT user_id FROM group_members WHERE group_id = %s)", (group_.id,))
                group_members_ = cur.fetchall()
                print(*group_members_)
        
                return render_template('group.html', group=group_, group_members=group_members_, group_meetings=group_meetings_)
            else:
                return render_template('index.html')


@app.route('/vote_meeting/<int:group_id>/<int:meeting_id>', methods=['POST'])
def vote_meeting(group_id, meeting_id):
    if request.method == 'POST':
        with connect_db() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT * FROM meetings WHERE id = %s", (meeting_id,))
                meeting_data = cur.fetchone()

                if meeting_data:
                    vote = request.form['vote']
                    if vote == 'yes':
                        cur.execute("UPDATE meetings SET vote_yes = vote_yes + 1 WHERE id = %s", (meeting_id,))
                    elif vote == 'no':
                        cur.execute("UPDATE meetings SET vote_no = vote_no + 1 WHERE id = %s", (meeting_id,))

                    cur.execute("SELECT * FROM meetings WHERE group_id = %s", (group_id,))
                    updated_meeting_data = cur.fetchall()

                    cur.execute("SELECT * FROM groups WHERE id = %s", (group_id,))
                    group_data = cur.fetchone()

                    if group_data:
                        group_ = Group(name=group_data[1], password=group_data[2], group_type=group_data[3])
                        group_.id = group_data[0]

                        cur.execute("SELECT login FROM users WHERE id IN (SELECT user_id FROM group_members WHERE group_id = %s)", (group_.id,))
                        group_members_ = cur.fetchall()

                        return render_template('group.html', group=group_, group_members=group_members_, group_meetings=updated_meeting_data)

# ---------------------------------------------------------------------------

@app.route('/')
def home():
    return render_template('home.html')

@app.route('/index')
def index():
    login = session.get('login', None)
    return render_template('index.html', login=login)

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        
        login = request.form.get('login')
        password = request.form.get('password')

        with connect_db() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT * FROM users WHERE login = %s", (login,))
                is_user_exists = cur.fetchone()
                if is_user_exists:
                    error_ = 'The user already exists! Come up with a different login or log in if the existing account belongs to you!'
                    return render_template('register.html', error=error_)
                else:
                    cur.execute("INSERT INTO users (login, password) VALUES (%s, %s) RETURNING id", (login, password))
                    id = cur.fetchone()[0]
        print(f"Registration was completed successfully! id: {id}, login: {login}, password: {password}")
        login_ = login
        return render_template('index.html', login=login_)

    return render_template('register.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        
        login = request.form.get('login')
        password = request.form.get('password')
        
        with connect_db() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT * FROM users WHERE login = %s", (login,))
                is_user_exists = cur.fetchone()
                if is_user_exists and password == is_user_exists[2]:
                    print(f"Log in was completed successfully! id: {id}, login: {login}, password: {password}")
                    session['login'] = login
                    return redirect(url_for('index'))
                elif is_user_exists and password != is_user_exists[2]:
                    error_ = 'Invalid password! Try again!'
                    return render_template('login.html', error=error_)
                else:
                    error_ = 'The user was not found! Register a new account!'
                    return render_template('login.html', error=error_)
    return render_template('login.html')


@app.route('/create_group', methods=['GET', 'POST'])
def create_group():
    if request.method == 'POST':
        
        name_ = request.form.get('name')
        password_ = secrets.token_urlsafe(4)
        group_type_ = request.form.get('type')
        
        login = session.get('login', None)
        
        with connect_db() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT * FROM groups WHERE name = %s", (name_,))
                is_group_exists = cur.fetchone()
                if is_group_exists:
                    error_ = 'The group already exists! Come up with a different name or join group if the existing group belongs to you or your friends!'
                    return render_template('create_group.html', error=error_)
                else:
                    cur.execute("INSERT INTO groups (name, password, type) VALUES (%s, %s, %s) RETURNING id", (name_, password_, group_type_))
                    group_ = Group(name=name_, password=password_, group_type=group_type_)
                    group_.id = cur.fetchone()[0]
                    
                    cur.execute("SELECT * FROM users WHERE login = %s", (login,))
                    user_id = cur.fetchone()[0]
                    cur.execute("INSERT INTO group_members (group_id, user_id) VALUES (%s, %s)", (group_.id, user_id))
                    
                    cur.execute("SELECT login FROM users WHERE id IN (SELECT user_id FROM group_members WHERE group_id = %s)", (group_.id,))
                    group_members_ = cur.fetchall()
                    print(*group_members_)
                    
        print(f"Group created successfully! group_id: {group_.id}, name: {name_}, password: {password_}, group_type: {group_type_}")
        return render_template('group.html', group=group_, group_members=group_members_)
    
    return render_template('create_group.html')


@app.route('/join_group', methods=['GET', 'POST'])
def join_group():
    if request.method == 'POST':
        
        password = request.form.get('password')
        
        login = session.get('login', None)

        with connect_db() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT * FROM groups WHERE password = %s", (password,))
                data = cur.fetchone()
                if data:
                    group_ = Group(name=data[1], password=data[2], group_type=[3])
                    group_.id = data[0]
                    
                    cur.execute("SELECT * FROM users WHERE login = %s", (login,))
                    user_id = cur.fetchone()[0]
                    
                    cur.execute("SELECT * FROM group_members WHERE group_id = %s AND user_id = %s", (group_.id, user_id))
                    is_user_in_group = cur.fetchone()
                    if is_user_in_group == None:
                        cur.execute("INSERT INTO group_members (group_id, user_id) VALUES (%s, %s)", (group_.id, user_id))
                    
                    cur.execute("SELECT login FROM users WHERE id IN (SELECT user_id FROM group_members WHERE group_id = %s)", (group_.id,))
                    group_members_ = cur.fetchall()
                    print(*group_members_)
                    
                    cur.execute("SELECT * FROM meetings WHERE group_id = %s", (group_.id,))
                    group_meetings_ = cur.fetchall()
                    if group_meetings_:
                        return render_template('group.html', group=group_, group_members=group_members_, group_meetings=group_meetings_)
                    else:
                        return render_template('group.html', group=group_, group_members=group_members_)
                else:
                    error_ = 'Invalid password! The group was not found!'         
                    return render_template('join_group.html', error=error_)
                
    return render_template('join_group.html')


if __name__ == '__main__':
    app.run(debug=True)
