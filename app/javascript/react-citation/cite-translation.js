import React from "react"
import PropTypes from "prop-types";
import TranscriptErrorDisclaimer from "./transcript-error-disclaimer";

const Translation = (props) => {
  return (
    <>
      <div className="ocr-transcript-info">
        <a data-toggle="modal" data-target="#transcriptModal" href="#">
          Why are there errors in the transcript?
        </a>
      </div>
      <div className="translation">{props.translation}</div>
      <TranscriptErrorDisclaimer />
    </>
  );
};

const propTypes = {
  translation: PropTypes.string.isRequired
}

Translation.propTypes = propTypes

export default Translation;
