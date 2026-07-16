import React from "react"
import PropTypes from "prop-types";
import TranscriptErrorDisclaimer from "./transcript-error-disclaimer";

const Transcript = (props) => {
  return (
    <>
      <div className="ocr-transcript-info">
        <a data-toggle="modal" data-target="#transcriptModal" href="#">
          More information about this transcript
        </a>
      </div>
      <div className="transcript">{props.transcript}</div>
      <TranscriptErrorDisclaimer />
    </>
  );
};

const propTypes = {
  transcript: PropTypes.string.isRequired
};

Transcript.propTypes = propTypes;

export default Transcript;
