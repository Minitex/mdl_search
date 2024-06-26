import React, { useState } from "react";
import { ModalListForm } from "./modal-list-form";
import { repo } from "./repo";
import { eventTracking } from "./event-tracking";

const CreateList = ({ onCreate, className }) => {
  const [modalOpen, setModalOpen] = useState(false);

  const closeModal = () => setModalOpen(false);
  const createList = async (name) => {
    const list = await repo.createList(name);
    onCreate(list);
    eventTracking.listCreated();
    closeModal();
  }

  return (
    <>
      <ModalListForm
        open={modalOpen}
        onSubmit={createList}
        onClose={closeModal}
        submitButtonText="Create List"
      />
      <button className={`btn ${className}`} onClick={() => setModalOpen(true)}>
        Create New List
      </button>
    </>
  );
};

export { CreateList };
