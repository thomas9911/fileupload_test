import "./App.css";

import React, { useState } from "react";
import { ApolloClient, ApolloProvider, InMemoryCache } from "@apollo/client";
import { useQuery, useMutation, gql } from "@apollo/client";
import { createUploadLink } from "apollo-upload-client";
import {useDropzone} from 'react-dropzone'

const client = new ApolloClient({
  link: createUploadLink({
    uri: "http://localhost:4001/graphql",
  }),
  cache: new InMemoryCache(),
});

const POSTS = gql`
  query GetExchangeRates {
    posts {
      id
      title
    }
  }
`;

const SINGLE_UPLOAD = gql`
  mutation($file: Upload!) {
    uploadFile(file: $file)
  }
`;

function MyDropzone({onDrop}) {
  // const onDrop = useCallback(acceptedFiles => {
  //   // Do something with the files
  // }, [])
  const {getRootProps, getInputProps, isDragActive} = useDropzone({onDrop})

  return (
    <div {...getRootProps()}>
      <input {...getInputProps()} />
      {
        isDragActive ?
          <p>Drop the files here ...</p> :
          <p>Drag 'n' drop some files here, or click to select files</p>
      }
    </div>
  )
}

const UploadFile = ({ setUrl }) => {
  const [mutate, { loading, error }] = useMutation(SINGLE_UPLOAD);
  // const onChange = ({
  //   target: {
  //     validity,
  //     files: [file],
  //   },
  // }) => {
  //   if (validity.valid) {
  //     // mutate({ variables: { file } }).then(x => {window.open(`http://localhost:4001/${x.data.uploadFile}`)})
  //     mutate({ variables: { file } }).then((x) => {
  //       setUrl(`http://localhost:4001/${x.data.uploadFile}`);
  //     });
  //   }
  // };

  const onDrop = ([file]) => {
    mutate({ variables: { file } }).then((x) => {
      setUrl(`http://localhost:4001/${x.data.uploadFile}`);
    });
  };

  if (loading) return <div>Loading...</div>;
  if (error) return <div>{JSON.stringify(error, null, 2)}</div>;

  return (
    // <React.Fragment>
    //   <input type="file" required onChange={onChange} accept="image/*" />
    // </React.Fragment>
    <MyDropzone onDrop={onDrop}/>
  );
};

function Posts() {
  const { loading, error, data } = useQuery(POSTS);

  if (loading) return <p>Loading...</p>;
  if (error) return <p>Error :(</p>;

  return data.posts.map(({ id, title }) => (
    <div key={id}>
      <p>
        {id}: {title}
      </p>
    </div>
  ));
}

function App() {
  const [imgUrl, setImgUrl] = useState("");
  return (
    <div className="App">
      <ApolloProvider client={client}>
        <UploadFile setUrl={setImgUrl} />
        <Posts />
      </ApolloProvider>
      <img src={imgUrl} alt="nah"></img>
    </div>
  );
}

export default App;
