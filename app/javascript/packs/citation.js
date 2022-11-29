import React from 'react';
import ReactDOM from 'react-dom';
import ReactCitation from '../react-citation/react-citation';

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('viewer_data')
  const viewerNode = document.getElementById('react-citation-viewer')
  const config = JSON.parse(node.getAttribute('citationConfig'))
  ReactDOM.render(
    <div className="row citation">
      <ReactCitation items={config } />
    </div>,
    viewerNode.appendChild(document.createElement('div')),
  );
});
