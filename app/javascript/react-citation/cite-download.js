import React from 'react'
import CiteThumbnail from './cite-thumbnail'

export default class Download extends React.Component {
  constructor(props) {
    super(props)
  }

  render() {
    let { fields, label }  = this.props
    return  (
              <div className="row">
                {fields.map(function(field, i) {
                  return <CiteThumbnail key={i} {...field}/>
                })}
              </div>
            )
  }
}

const propTypes = {
  fields: React.PropTypes.array.isRequired
}

Download.propTypes = propTypes