import React from 'react'
import PropTypes from 'prop-types';

const Modal = () => {
  return (
    <div className="modal" id="transcriptModal" tabIndex="-1" role="dialog">
      <div className="modal-dialog" role="document">
        <div className="modal-content">
          <div className="modal-header transcript-ocr">
            <button type="button" className="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
            <h5 className="modal-title">Optical Character Recognition Text</h5>
          </div>
          <div className="modal-body">
            <p>Why are there errors in the transcript?</p>
            <p>
              Optical Character Recognition, or OCR*, is a process by which software
              reads a page image and translates it into a text file by recognizing
              the shapes of the letters. We perform OCR on text-based resources,
              like books and letters, to enable full-text searching.
            </p>
            <p>
              However, OCR is seldom completely accurate. The level of accuracy
              depends on the print quality of the original materials, their condition
              at the time of digitization, the level of detail captured by scanners,
              and the quality of the OCR software. Scans of pages with poor quality
              paper, small or faded print, mixed fonts, multiple column layouts, or
              damage may result in low OCR accuracy.
            </p>

            <p>
              The searchable text in this transcript has been automatically generated
              using OCR software. It has not been manually reviewed or corrected.
            </p>

            <p>
              *Source:
              <a href="https://www.ninch.org/guide.pdf" target="_blank" rel="noopener">
                The NINCH Guide to Good Practice in the Digital Representation and Management of Cultural Heritage Materials.
              </a>
            </p>
          </div>
          <div className="modal-footer transcript-ocr">
            <button
              type="button"
              className="btn btn-secondary modal-dismiss"
              data-dismiss="modal"
            >Close</button>
          </div>
        </div>
      </div>
    </div>
  );
};

const Transcript = (props) => {
  return (
    <>
      <div className="ocr-transcript-info">
        <a data-toggle="modal" data-target="#transcriptModal" href="#">
          Why are there errors in the transcript?
        </a>
      </div>
      <div className="transcript">{props.transcript}</div>
      <Modal />
    </>
  );
};

const propTypes = {
  transcript: PropTypes.string.isRequired
}

Transcript.propTypes = propTypes

export default Transcript
