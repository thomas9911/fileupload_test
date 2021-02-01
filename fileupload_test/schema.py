import graphene
from graphene_file_upload.scalars import Upload
from settings import UPLOAD_FOLDER
from werkzeug.utils import secure_filename


class UploadMutation(graphene.Mutation):
    class Arguments:
        file = Upload(required=True)

    # success = graphene.String()
    Output = graphene.String

    def mutate(self, info, file, **kwargs):
        if file.content_type in ["image/png"]:
            new_name = secure_filename(file.filename)
            file.save(f"{UPLOAD_FOLDER}{new_name}")

            # return UploadMutation(success="yes")
            return f"uploads/{new_name}"
        raise TypeError("Should be an image")


class Post(graphene.ObjectType):
    id = graphene.ID(required=True)
    title = graphene.String()
    body = graphene.String()


class Query(graphene.ObjectType):
    posts = graphene.List(Post)

    def resolve_posts(root, info):
        return [
            {"id": 1, "title": "Oke", "body": "bla"},
            {"id": 2, "title": "Oke2", "body": "bla"},
            {"id": 3, "title": "Oke3", "body": "bla"},
        ]


class Mutations(graphene.ObjectType):
    upload_file = UploadMutation.Field()


schema = graphene.Schema(query=Query, mutation=Mutations)
