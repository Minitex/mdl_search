import React from 'react'
import PropTypes from 'prop-types';
import DetailsFieldValue from './cite-details-field-value'

export default class DetailsField extends React.Component {
  constructor(props) {
    super(props)
  }

  render() {
    let { field_values, label, delimiter} = this.props
    const field_class = `detail-field-${label.replace(/\s/g, '').toLowerCase()}`
    return (
             <span className={field_class}>
                <dt className="field-label">
                  <label className='label label-default'>{label}:</label>
                </dt>
                <dd className="field-definition">
                  {field_values.map(function(field_value, i) {
                    delimiter = (i < field_values.length - 1) ? delimiter : ''
                    return (<DetailsFieldValue key={i} url={field_value.url} text={field_value.text} delimiter={delimiter} />)
                  })}
                </dd>
             </span>
    )
  }
}

const propTypes = {
  label: PropTypes.string.isRequired,
  delimiter: PropTypes.string,
  url: PropTypes.string,
  field_values: PropTypes.array.isRequired
}

DetailsField.propTypes = propTypes
