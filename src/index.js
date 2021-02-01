const fs = require("fs");

const express = require("express");
const { ApolloServer, gql } = require("apollo-server-express");

const typeDefs = gql`
  type Post {
    id: ID
    title: String
    body: String
  }

  type Query {
    posts: [Post]
  }

  type Mutation {
    uploadFile(file: Upload!): String
  }
`;

const posts = [
  { id: 1, title: "Oke", body: "bla" },
  { id: 2, title: "Oke2", body: "bla" },
  { id: 3, title: "Oke3", body: "bla" },
];

const resolvers = {
  Query: {
    posts: () => posts,
  },
  Mutation: {
    uploadFile: (parent, args) => {
      return args.file.then((file) => {
        //Contents of Upload scalar: https://github.com/jaydenseric/graphql-upload#class-graphqlupload
        //file.createReadStream() is a readable node stream that contains the contents of the uploaded file
        //node stream api: https://nodejs.org/api/stream.html
        const newName = file.filename.split(" ").join("+");
        var writeStream = fs.createWriteStream(`./uploaded/${newName}`);
        const readStream = file.createReadStream();
        readStream.pipe(writeStream);

        readStream.on("error", (err) => {
          console.log(err);
        });
        return `uploads/${newName}`;
      });
    },
  },
};

const server = new ApolloServer({
  typeDefs,
  resolvers,
  cors: true,
  playground: true,
  introspection: true,
});

const app = express();
app.use("/uploads", express.static("uploaded"));
server.applyMiddleware({ app });

app.listen({ port: 4001 }, () => {
  console.log(`🚀  Server ready`);
});
