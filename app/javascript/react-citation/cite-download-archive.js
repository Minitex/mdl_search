import React, { Fragment, useState, useRef, useEffect } from "react";
import Recaptcha from "react-google-recaptcha";

const CiteDownloadArchive = ({ readyUrl, downloadRequestUrl, itemId }) => {
  const [loading, setLoading] = useState(true);
  const [failed, setFailed] = useState(false);
  const [statusUrl, setStatusUrl] = useState();
  const [status, setStatus] = useState();
  const [storageUrl, setStorageUrl] = useState();
  const [progress, setProgress] = useState(0);
  const captchaRef = useRef(null);

  useEffect(() => {
    window.fetch(readyUrl, {
      method: "GET",
      headers: {
        "Accept": "application/json"
      }
    })
    .then(response => {
      if (!response.ok) {
        throw new Error(`Ready response was not ok. status: ${response.status}`);
      }
      return response.json();
    })
    .then(json => {
      setStatus(() => json.status);
      setStorageUrl(() => json.storage_url);
      setProgress(100);
      setLoading(false);
    })
    .catch(_err => setLoading(false))
  }, []);

  // start polling the statusUrl for updates
  useEffect(() => {
    if (!statusUrl) { return }

    const timer = window.setInterval(() => {
      window.fetch(statusUrl, {
        method: "GET",
        headers: {
          "Accept": "application/json"
        }
      })
      .then(response => response.json())
      .then(json => {
        setStatus(() => json.status);
        setStorageUrl(() => json.storage_url);
      })
    }, 5000);

    if (status === "stored") {
      clearInterval(timer);
    }

    return () => window.clearInterval(timer);
  }, [statusUrl, status]);

  // Manages the progress bar, allowing it to fill up to 95% on the timer.
  // Wait for the status to be "stored" before filling it completely.
  useEffect(() => {
    if (!status) { return }

    const timer = window.setInterval(() => {
      const max = 95;
      if (progress < max) {
        setProgress(prevProg => prevProg + 0.5);
      }
    }, 500);

    if (progress < 80 && status === "generated") {
      setProgress(80);
    }
    if (status === "stored") {
      setProgress(100);
    }

    return () => window.clearInterval(timer);
  }, [status, progress]);

  const requestDownload = (e) => {
    e.preventDefault();
    const token = captchaRef.current.getValue();
    if (!token) { return }
    setLoading(true);
    captchaRef.current.reset();
    window.fetch(downloadRequestUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: JSON.stringify({ id: itemId, token })
    })
    .then(response => {
      if (response.ok) {
        setFailed(false);
        setStatusUrl(response.headers.get("Location"));
      } else {
        setFailed(true);
      }
      return response.json();
    })
    .then(json => {
      setStatus(json.status);
      setStorageUrl(json.storage_url);
    })
    .then(() => setLoading(false));
  }
  return (
    <Fragment>
      {failed && (
        <div className="alert alert-danger" role="alert">
          Download request failed; please try again.
        </div>
      )}
      {!status && !loading && (
        <Fragment>
          <p>Download all the media files for this item in a single zip file</p>

          <form onSubmit={requestDownload} disabled={loading}>
            <Recaptcha sitekey="6LdB0j4jAAAAAO2W4TPkRDYmF258b0PfIJA8azr4" ref={captchaRef} />
            <button className="btn btn-primary request-download">
              Download ZIP
            </button>
          </form>
        </Fragment>
      )}
      {statusUrl && status && (
        <Fragment>
          <div className="progress">
            <div
              className={`progress-bar progress-bar-striped ${progress < 100 ? "progress-bar-animated" : ""}`}
              role="progressbar"
              style={{width: `${progress}%`}}
              aria-valuemin="0"
              aria-valuemax="100"
              aria-valuenow={progress}
            ></div>
          </div>
          {progress < 100 && <p>Generating ZIP file...</p>}
          {progress === 100 && <p>Your download is ready.</p>}
        </Fragment>
      )}
      {storageUrl && (
        <Fragment>
          <a
            className="btn btn-success"
            href={storageUrl}
            target="_blank"
          >Download</a>
        </Fragment>
      )}
    </Fragment>
  );
};

export default CiteDownloadArchive;
