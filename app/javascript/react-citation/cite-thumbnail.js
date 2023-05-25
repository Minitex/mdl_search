import React from 'react';
import PropTypes from 'prop-types';
import DownloadSource from './cite-download-source';
import { LazyLoadImage } from 'react-lazy-load-image-component';

class CiteThumbnail extends React.Component {
  constructor(props) {
    super(props)
  }

  render() {
    let { thumbnail, label, sources, className } = this.props;
    return (
      <div className={`${className} download-source row`}>
        <LazyLoadImage className="thumbnail" src={thumbnail} />
        <div title={label} className="download-label col-md-12">{label}</div>
        {sources.map((source, i) => <DownloadSource key={i} {...source} />)}
      </div>
    )
  }
}

const propTypes = {
  thumbnail: PropTypes.string.isRequired,
  sources: PropTypes.array.isRequired,
  className: PropTypes.string.isRequired,
}

CiteThumbnail.propTypes = propTypes

export default CiteThumbnail

