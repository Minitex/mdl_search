import React from 'react'

export default class DetailsFieldValue extends React.Component {
  constructor(props) {
    super(props)
    this._field =  this._field.bind(this)
    this._link  =  this._link.bind(this)
    this._danger = this._danger.bind(this)
    this._delimiter = this._delimiter.bind(this)
    this._text = this._text.bind(this)
  }

  _createMarkup(value) {
    return ({__html: value})
  }

  _link() {
    return `<a href="${this.props.url}">${this.props.text}</a>`
  }

  _field() {
    if (this.props.url) {
      return this._danger(this._link())
    } else {
      return this._danger(this.props.text)
    }
  }

  _danger(html) {
    return <div dangerouslySetInnerHTML={this._createMarkup(html)} />
  }

  _text() {
    return (this.props.text == 'undefined') ? this._danger(this.props.text) : ''
  }

  _delimiter() {
    return (this.props.delimiter == 'undefined') ? this._danger(this.props.delimiter) : ''
  }

  render() {
    return <span>{this._field()}{this._delimiter()}</span>
  }
}

const propTypes = {
  text: React.PropTypes.string.isRequired,
  delimiter: React.PropTypes.string,
  url: React.PropTypes.string
}

DetailsFieldValue.propTypes = propTypes