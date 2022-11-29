import React from 'react'
import PropTypes from 'prop-types';
import DownloadSource from './cite-download-source'

class CiteThumbnail extends React.Component {
  constructor(props) {
    super(props)
  }

  render() {
    let { thumbnail, sources } = this.props
    return  (
              <div className="col-md-2 download-source">
                <img className="thumbnail" src={thumbnail} />
                {sources.map((source, i) => {
                  return <DownloadSource key={i} {...source} />
                })}
              </div>
            )
  }
}

const propTypes = {
  thumbnail: PropTypes.string.isRequired,
  sources: PropTypes.array.isRequired
}

CiteThumbnail.propTypes = propTypes

export default CiteThumbnail

