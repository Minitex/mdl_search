import React, { useState, useEffect } from "react";
import { repo } from "./repo";
import { ModalListForm } from "./modal-list-form";

const MyLists = () => {
  const [lists, setLists] = useState({});
  const [dirtiedAt, setDirtiedAt] = useState(repo.now());
  const [modalOpen, setModalOpen] = useState(false);

  const loadLists = async () => {
    const myLists = await repo.loadLists();
    if (myLists) {
      setLists(myLists);
    }
  };

  useEffect(() => {
    loadLists();
  }, [dirtiedAt]);

  const createList = async (name) => {
    await repo.createList(name);
    setDirtiedAt(repo.now());
    closeModal();
  }

  const closeModal = () => setModalOpen(false);

  return (
    <div className="container">
      <h1>My Lists</h1>
      <div className="row">
        <div className="col">
          <p>
            <strong>Note:</strong> You won't see lists created in another browser here. To view those lists, open the browser you used when creating them.
          </p>
          <button
            className="btn btn-primary"
            onClick={() => setModalOpen(true)}>
            Add List
          </button>
        </div>
      </div>
      <ModalListForm
        open={modalOpen}
        onClose={closeModal}
        onSubmit={createList}
        submitButtonText="Create"
      />
      <div className="row mt-3">
        {Object.entries(lists).map(([id, list]) => {
          return (
            <div key={id} className="mb-3 col-xs-12 col-lg-6">
              <div className="card">
                <div className="card-body">
                  <h4 className="card-title">
                    <a href={`/lists/${id}`}>{list.name}</a>
                  </h4>
                  <p className="card-text">{list.count} {list.count == 1 ? "item" : "items"}</p>
                </div>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}

export { MyLists };
