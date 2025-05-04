from flask import Flask, request, jsonify
from schemas import ProjectSchema, TaskSchema, task_schema
from flask_cors import CORS
from models import db, Project, Task
import random, string

app = Flask(__name__)
CORS(app)

# Config SQLite
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///database.db'
db.init_app(app)

# Schema instance
project_schema = ProjectSchema()

# Generate 6-character alphanumeric ID
def generate_id():
    return ''.join(random.choices(string.ascii_uppercase + string.digits, k=6))

# Create Project
@app.route('/api/projects/', methods=['POST'])
def create_project():
    print("📥 Incoming Project JSON:", request.json)
    try:
        data = project_schema.load(request.json)
    except Exception as e:
        return jsonify({'error': str(e)}), 400

    new_id = generate_id()
    while Project.query.get(new_id):
        new_id = generate_id()

    project = Project(id=new_id, name=data['name'], short_id=data['short_id'], color=data['color'])
    db.session.add(project)
    db.session.commit()
    return jsonify({'project_id': new_id, 'project': project_schema.dump(project)}), 201

# Get Project
@app.route('/api/projects/<project_id>', methods=['GET'])
def get_project(project_id):
    project = Project.query.get(project_id)
    if not project:
        return jsonify({'error': 'Project not found'}), 404
    return jsonify({'project_id': project_id, 'project': project_schema.dump(project)})

# Update Project
@app.route('/api/projects/<project_id>', methods=['PUT'])
def update_project(project_id):
    project = Project.query.get(project_id)
    if not project:
        return jsonify({'error': 'Project not found'}), 404

    try:
        data = request.json
        project.data = data.get('data', project.data)
        db.session.commit()
        return jsonify({'project_id': project_id, 'project': project_schema.dump(project)})
    except Exception as e:
        return jsonify({'error': str(e)}), 400

@app.route('/api/projects/<project_id>/days/<int:day_index>/tasks', methods=['POST'])
def create_task(project_id, day_index):
    try:
        task: Task = task_schema.load(request.json)

        task.project_id = project_id
        task.day_index = day_index

        db.session.add(task)
        db.session.commit()

        return jsonify({'message': 'Task created', 'task': task_schema.dump(task)}), 201

    except Exception as e:
        return jsonify({'error': str(e)}), 400

@app.route('/api/projects/<project_id>/days/<int:day_index>/tasks', methods=['GET'])
def get_tasks_for_day(project_id, day_index):
    tasks = Task.query.filter_by(project_id=project_id, day_index=day_index).all()
    return jsonify([task_schema.dump(task) for task in tasks]), 200
    
@app.route('/api/tasks/<int:task_id>/priority', methods=['PATCH'])
def update_task_priority(task_id):
    task = Task.query.get(task_id)
    if not task:
        return jsonify({'error': 'Task not found'}), 404

    data = request.json
    if 'priority' not in data:
        return jsonify({'error': 'Missing priority field'}), 400

    task.priority = data['priority']
    db.session.commit()
    return jsonify({'message': 'Priority updated', 'task': task_schema.dump(task)})
    
@app.route('/api/projects/by_short_id/<short_id>', methods=['GET'])
def get_project_by_short_id(short_id):
    project = Project.query.filter_by(short_id=short_id).first()
    if not project:
        return jsonify({'error': 'Project not found'}), 404
    return jsonify({'project_id': project.id, 'project': project_schema.dump(project)})

@app.route('/api/tasks/<int:task_id>', methods=['DELETE'])
def delete_task(task_id):
    task = Task.query.get(task_id)
    if not task:
        return jsonify({'message': 'Task not found'}), 404

    db.session.delete(task)
    db.session.commit()
    return jsonify({'message': 'Task deleted'}), 200
