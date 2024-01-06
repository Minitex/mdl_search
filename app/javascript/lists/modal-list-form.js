import React from "react";
import { Modal } from "./modal";
import { ListForm } from "./list-form";

const ModalListForm = ({
  onSubmit,
  submitButtonText,
  open,
  onClose,
  name,
}) => {
  return (
    <Modal open={open} onClose={onClose} title="Name Your List">
      {open && (<ListForm
        onSubmit={onSubmit}
        onCancel={onClose}
        submitButtonText={submitButtonText}
        name={name}
      />)}
    </Modal>
  );
};

export { ModalListForm };
