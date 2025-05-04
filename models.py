from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import event

db = SQLAlchemy()

class Project(db.Model):
    id = db.Column(db.String(6), primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    short_id = db.Column(db.String(20), nullable=False)
    color = db.Column(db.String(7), nullable=False)

class Task(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    subtitle = db.Column(db.String(200))
    priority = db.Column(db.Integer, nullable=False)
    date = db.Column(db.String(20), nullable=False)
    day_index = db.Column(db.Integer, nullable=False)
    project_id = db.Column(db.String(6), db.ForeignKey('project.id'), nullable=False)
