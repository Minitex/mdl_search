import React from 'react'
import PropTypes from 'prop-types';

export default class CiteDownloadSource extends React.Component {
  constructor(props) {
    super(props)
  }

  render() {
    let { label, src } = this.props
    return (
      <div className="col text-center download-source-link">
        <a href={src} target="_blank" rel="noopener">
          <span className="glyphicon glyphicon-download-alt"></span> {label}
        </a>
      </div>
    )
  }
}

const propTypes = {
  src: PropTypes.string.isRequired,
  label: PropTypes.string.isRequired,
}

CiteDownloadSource.propTypes = propTypes
