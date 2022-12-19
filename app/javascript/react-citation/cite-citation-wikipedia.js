import React from 'react'
import PropTypes from 'prop-types';
import citationRender from './cite-citation-render'

class CitationWikipedia extends React.Component {
  constructor(props) {
    super(props)
  }

  removeProtocols(url) {
    return url.replace(/http:\/\/|https:\/\//i, '')
  }

  mappings() {
    let map =
          [
            {ref_name: {prefix: '<ref name=', suffix: '> {{' }},
            {url: {prefix: 'cite web | url=', suffix: ''}},
            {type: {prefix: ' | title= (', suffix: ') '}},
            {title: {prefix: '', suffix: ','}},
            {creation_date: {prefix: '(', suffix: ')' }},
            {creator: {prefix: ' | author=', suffix: '' }},
            {current_date: {prefix: ' | accessdate=', suffix: '' }},
            {contributing_organization: {prefix: ' | publisher=', suffix: '}} </ref>' }}
          ]
    return map
  }

  render() {
    return this.props.render_citation({mappings: this.mappings()})
  }
}

const propTypes = {
  ref_name: PropTypes.string,
  creator: PropTypes.string,
  creation_date: PropTypes.string,
  title: PropTypes.string,
  contributing_organization: PropTypes.string,
  url: PropTypes.string,
  mapping: PropTypes.object
}

CitationWikipedia.propTypes = propTypes

export default citationRender(CitationWikipedia)
