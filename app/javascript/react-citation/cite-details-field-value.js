import React from 'react'
import PropTypes from 'prop-types';

export default class DetailsFieldValue extends React.Component {
  constructor(props) {
    super(props)
    this._field =  this._field.bind(this)
    this._danger = this._danger.bind(this)
    this._delimiter = this._delimiter.bind(this)
    this._text = this._text.bind(this)
  }

  _createMarkup(value) {
    return ({__html: value})
  }

  _field() {
    if (this.props.url) {
      return (
        <a href={this.props.url} data-turbolinks="false">
          {this.props.text}
        </a>
      );
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
    return <div>{this._field()}{this._delimiter()}</div>
  }
}

const propTypes = {
  text: PropTypes.string.isRequired,
  delimiter: PropTypes.string,
  url: PropTypes.string
}

DetailsFieldValue.propTypes = propTypes
