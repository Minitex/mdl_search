import React from 'react'

export default class CiteDownloadSource extends React.Component {
  constructor(props) {
    super(props)
  }

  render() {
    let { label, src }  = this.props
    return  (
              <div>
                <a href={src}>
                  <span className="glyphicon glyphicon-download-alt"></span> {label}
                </a>
              </div>
            )
  }
}

const propTypes = {
  src: React.PropTypes.string.isRequired,
  label: React.PropTypes.string.isRequired,
}

CiteDownloadSource.propTypes = propTypes