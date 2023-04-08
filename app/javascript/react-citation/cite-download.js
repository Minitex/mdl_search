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
        {fields.map((field, i) => (
          <CiteThumbnail
            key={i}
            className={`col-md-${cols}`}
            {...field}
          />
        ))}
      </div>
    )
  }
}

const propTypes = {
  fields: PropTypes.array.isRequired
}

Download.propTypes = propTypes
