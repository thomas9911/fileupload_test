from flask import send_from_directory, Flask
from flask_graphql import GraphQLView
from flask_cors import CORS

from graphene_file_upload.flask import FileUploadGraphQLView
from schema import schema
from settings import UPLOAD_FOLDER


app = Flask(__name__)
CORS(app)
app.config["MAX_CONTENT_LENGTH"] = 16 * 1024 * 1024
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER


@app.route("/uploads/<filename>")
def uploaded_file(filename):
    return send_from_directory(app.config["UPLOAD_FOLDER"], filename)


app.add_url_rule(
    "/graphql",
    view_func=FileUploadGraphQLView.as_view(
        "graphql",
        schema=schema,
        graphiql=True,
    ),
)
