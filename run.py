from app import app, db

with app.app_context():
    db.create_all()  # Creates tables if they don’t exist

app.run(debug=True)
