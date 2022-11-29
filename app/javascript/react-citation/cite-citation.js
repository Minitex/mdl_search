import React from 'react'
import CitationCoins from './cite-citation-coins'
import CitationChicago from './cite-citation-chicago'
import CitationMla from './cite-citation-mla'
import CitationWikipedia from './cite-citation-wikipedia'

export default class Citation extends React.Component {
  constructor(props) {
    super(props)
  }

  render() {
    let fields = this.props.fields
    return (
        <div className="citation">
          <div><CitationCoins {...fields} /></div>
          <h3>Chicago Style</h3>
          <div><CitationChicago {...fields} /></div>
          <h3>MLA Style</h3>
          <div><CitationMla {...fields} /></div>
          <h3>Wikipedia Style</h3>
          <div><CitationWikipedia {...fields} /></div>
        </div>
      )
  }
}

const propTypes = {
  fields: React.PropTypes.array,
  mapping: React.PropTypes.object
}

CitationChicago.propTypes = propTypes