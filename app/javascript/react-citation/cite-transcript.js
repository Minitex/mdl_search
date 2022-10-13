import React from 'react'

const Transcript = props => (<div className="transcript">{props.transcript}</div>)

const propTypes = {
  transcript: React.PropTypes.string.isRequired
}

Transcript.propTypes = propTypes

export default Transcript