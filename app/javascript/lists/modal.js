import React from "react";

const Modal = ({ open, onClose, title, children }) => {
  return (
    <>
      <div className={`modal fade ${open && "show d-block"}`} tabIndex="-1" role="dialog">
        <div className="modal-dialog" role="document">
          <div className="modal-content">
            <div className="modal-header d-flex">
              <h5 className="modal-title">{title}</h5>
              <button type="button" className="close" data-dismiss="modal" aria-label="Close" onClick={onClose}>
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <div className="modal-body">
              {children}
            </div>
          </div>
        </div>
      </div>
      {open && <div className="modal-backdrop fade show"></div>}
    </>
  );
};

export { Modal };
