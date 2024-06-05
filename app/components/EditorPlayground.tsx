import Editor from '@monaco-editor/react';

function EditorPlayground() {
  return (
    <Editor
      height="60vh"
      width="45vw"
      defaultLanguage="javascript"
      defaultValue="console.log('Hello world!')"
      theme="vs-dark"
      options={{
        minimap: {
          enabled: false,
        },
      }}
    />
  );
}

export default EditorPlayground;
