import React from 'react'
import PropTypes from 'prop-types';
import citationRender from './cite-citation-render'

class CitationCoins extends React.Component {
  constructor(props) {
    super(props)
    this.mappings = this.mappings.bind(this)
  }


  mulitvalue_field(values) {
    values.join(',')
  }

  mappings() {
    let defaultMapping =
          [
            {creator: {prefix: '&amp;rft.creator', suffix: '', formatters: [encodeURIComponent]}},
            {creation_date: {prefix: ' ', suffix: '.', formatters: [encodeURIComponent]}},
            {title: {prefix: '&amp;rft.title=', suffix: '', formatters: [encodeURIComponent]}},
            {description: {prefix: '&amp;rft.description=', suffix: '', formatters: [encodeURIComponent]}},
            {subject: {prefix: '&amp;rft.subject=', suffix: '' , formatters: [this.mulitvalue_field, encodeURIComponent]}},
            {description: {prefix: '&amp;rft.description=', suffix: '', formatters: [encodeURIComponent]}},
            {contributing_organization: {prefix: 'publisher', suffix: '', formatters: [encodeURIComponent]}},
            {type: {prefix: '&amp;rft.type=', suffix: '', formatters: [encodeURIComponent]}},
            {format: {prefix: '&amp;rft.format=', suffix: '', formatters: [encodeURIComponent]}},
            {rights: {prefix: '&amp;rft.rights=', suffix: '', formatters: [encodeURIComponent]}},
            {url: {prefix: '&amp;rft.identifier=', suffix: '', formatters: [encodeURIComponent]}}
          ]
    return this.props.override_mappings(defaultMapping)
  }

  render() {
    let title = "ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Adc"
    return this.props.render_citation({prefix: '<span className="Z3988" title=' + title, suffix: '</span>', mappings: this.mappings(), render_html: true})
  }
}

const propTypes = {
  creator: PropTypes.string,
  creation_date: PropTypes.string,
  title: PropTypes.string,
  description: PropTypes.string,
  contributing_organization: PropTypes.string,
  type: PropTypes.string,
  format: PropTypes.string,
  rights: PropTypes.string,
  url: PropTypes.string,
  mapping: PropTypes.object
}

CitationCoins.defaultProps = {
  mappings: [{}]
}

CitationCoins.propTypes = propTypes

export default citationRender(CitationCoins)
