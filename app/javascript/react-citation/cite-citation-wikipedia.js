import React from 'react'
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
  ref_name: React.PropTypes.string, 
  creator: React.PropTypes.string,
  creation_date: React.PropTypes.string,
  title: React.PropTypes.string,
  contributing_organization: React.PropTypes.string,
  url: React.PropTypes.string,
  mapping: React.PropTypes.object
}

CitationWikipedia.propTypes = propTypes

export default citationRender(CitationWikipedia)