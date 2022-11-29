import React from 'react'
import PropTypes from 'prop-types';
import citationRender from './cite-citation-render'

class CitationChicago extends React.Component {
  constructor(props) {
    super(props)
  }

  mappings() {
    let map =
      [
        {creator: {prefix: '', suffix: '.' }},
        {creation_date: {prefix: ' ', suffix: '. ' }},
        {title: {prefix: '"', suffix: '." '}},
        {contributing_organization: {prefix: ' ', suffix: ', ' }},
        {current_date: {prefix: 'Accessed ', suffix: '. ', formatters: [this.format_date]}},
        {url: {prefix: '', suffix: '' }}
      ]
    return map
  }

  format_date(timestamp) {
    let date = new Date(timestamp)
    let months = ['January','February','March','April','May','June','July','August','September','October','November','December']
    let month = months[date.getMonth()]
    let year  = date.getFullYear()
    let day = date.getDate()
    return month + ' ' + day + ', ' + year
  }

  render() {
    return this.props.render_citation({mappings: this.mappings()})
  }
}

const propTypes = {
  creator: PropTypes.string,
  creation_date: PropTypes.string,
  title: PropTypes.string,
  contributing_organization: PropTypes.string,
  url: PropTypes.string,
  mapping: PropTypes.object
}

CitationChicago.propTypes = propTypes

export default citationRender(CitationChicago)
