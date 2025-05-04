from marshmallow import Schema, fields, EXCLUDE
from marshmallow_sqlalchemy import SQLAlchemyAutoSchema
from models import Task, db

class ProjectSchema(Schema):
    name = fields.String(required=True)
    short_id = fields.String(required=True)
    color = fields.String(required=True)

from marshmallow_sqlalchemy import SQLAlchemySchema, auto_field
from models import Task

class TaskSchema(SQLAlchemySchema):
    class Meta:
        model = Task
        load_instance = True

    id = auto_field(dump_only=True)
    title = auto_field(required=True)
    subtitle = auto_field(allow_none=True)
    priority = auto_field(required=True)
    date = auto_field(required=True)
    day_index = auto_field()
    project_id = auto_field()


project_schema = ProjectSchema()
projects_schema = ProjectSchema(many=True)
task_schema = TaskSchema()
tasks_schema = TaskSchema(many=True)
task_schema = TaskSchema(session=db.session)
