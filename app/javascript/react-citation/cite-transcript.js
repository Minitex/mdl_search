import React from 'react'
import PropTypes from 'prop-types';

const Transcript = props => (<div className="transcript">{props.transcript}</div>)

const propTypes = {
  transcript: PropTypes.string.isRequired
}

Transcript.propTypes = propTypes

export default Transcript
