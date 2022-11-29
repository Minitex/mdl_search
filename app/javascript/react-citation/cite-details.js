import React from 'react'
import PropTypes from 'prop-types';
import DetailsField from './cite-details-field'

export default class Details extends React.Component {
  constructor(props) {
    super(props)
  }

  render() {
    let { fields }  = this.props
    return (
        <dl className="row details">
          {fields.map(function(field, i) {
            return <DetailsField key={i} {...field} />
          })}
        </dl>
      )
  }
}

const propTypes = {
  fields: PropTypes.array.isRequired
}

Details.propTypes = propTypes
