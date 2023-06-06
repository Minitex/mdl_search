import React from 'react'
import PropTypes from 'prop-types';
import CiteThumbnail from './cite-thumbnail'

export default class Download extends React.Component {
  constructor(props) {
    super(props)
  }

  render() {
    let { fields } = this.props
    let cols = fields.length > 6 ? 2 : Math.floor(12 / fields.length);

    return (
      <div className="row">
        {fields.map((field, i) => {
          let { thumbnail, src, label } = field;
          return <CiteThumbnail
            key={i}
            className={`col-xs-12 col-sm-6 col-md-4 col-lg-${cols}`}
            thumbnail={thumbnail}
            src={src}
            label={label}
          />
        })}
      </div>
    )
  }
}

const propTypes = {
  fields: PropTypes.array.isRequired
}

Download.propTypes = propTypes
