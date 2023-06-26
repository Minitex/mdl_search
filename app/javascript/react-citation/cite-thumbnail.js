import React from 'react';
import PropTypes from 'prop-types';
import { LazyLoadImage } from 'react-lazy-load-image-component';

class CiteThumbnail extends React.Component {
  constructor(props) {
    super(props)
  }

  render() {
    let { thumbnail, label, src, className } = this.props;
    return (
      <a href={src} target="_blank" rel="noopener" className={`${className} download-source`}>
        <div className="download-thumbnail-wrapper">
          <LazyLoadImage className="thumbnail download-thumbnail" src={thumbnail}/>
          <div title={label} className="download-label">{label}</div>
        </div>
      </a>
    )
  }
}

const propTypes = {
  thumbnail: PropTypes.string.isRequired,
  src: PropTypes.array.isRequired,
  className: PropTypes.string.isRequired,
  label: PropTypes.string.isRequired,
}

CiteThumbnail.propTypes = propTypes

export default CiteThumbnail

