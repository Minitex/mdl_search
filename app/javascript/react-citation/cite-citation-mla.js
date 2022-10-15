import React from 'react'
import PropTypes from 'prop-types';
import citationRender from './cite-citation-render'

class CitationMla extends React.Component {
  constructor(props) {
    super(props)
  }

  italicize(text) {
    return '<i>' + text + '</i>'
  }

  removeProtocols(url) {
    return url.replace(/http:\/\/|https:\/\//i, '')
  }

  format_date(timestamp) {
    let date = new Date(timestamp)
    let months = ['Jan','Feb.','Mar.','Apr.','May','June','July','Aug.','Sept.','Oct.','Nov.','Dec.']
    let month = months[date.getMonth()]
    let year  = date.getFullYear()
    let day = date.getDate()
    return day + ' ' + month + ' ' + year

  }

  mappings() {
    let map =
          [
            {creator: {prefix: '', suffix: '.' }},
            {title: {prefix: ' ', suffix: '.', formatters: [this.italicize] }},
            {creation_date: {prefix: ' ', suffix: '.' }},
            {contributing_organization: {prefix: ' ', suffix: ', ' }},
            {url: {prefix: '', suffix: '', formatters: [this.removeProtocols] }},
            {current_date: {prefix: ' Accessed ', suffix: '.', formatters: [this.format_date] }}
          ]
    return map
  }

  render() {
    return this.props.render_citation({mappings: this.mappings(), render_html: true})
  }
}

const propTypes = {
  creator: PropTypes.string,
  creation_date: PropTypes.string,
  title: PropTypes.object,
  contributing_organization: PropTypes.string,
  url: PropTypes.string,
  mapping: PropTypes.object
}

CitationMla.propTypes = propTypes

export default citationRender(CitationMla)
