import React, { useEffect, useState } from "react";
import { repo } from "./repo";
import { ModalListForm } from "./modal-list-form";
import { Modal } from "./modal";
import { ListItem } from "./list-item";
import { generateCsv } from "./generate-csv";

const List = ({ listId }) => {
  const [list, setList] = useState({});
  const [items, setItems] = useState([]);
  const [editing, setEditing] = useState(false);
  const [updatedAt, setUpdatedAt] = useState(repo.now());
  const [deleting, setDeleting] = useState(false);
  const [alertText, setAlertText] = useState("");

  useEffect(() => {
    (async () => {
      await loadList();
    })();
  }, [listId, updatedAt]);

  useEffect(() => {
    if (list && list.selectedHash) {
      (async () => {
        const itemIds = Object.keys(list.selectedHash).join(",");
        if (!itemIds.length) { return; }
        const response = await window.fetch(`/lists/items/${itemIds}`);
        const body = await response.json();
        setItems(body.items);
      })();
    }
  }, [list]);

  const loadList = async () => {
    let l = await repo.loadList(listId);
    setList(l);
  }

  const editList = () => setEditing(true);
  const closeEditModal = () => setEditing(false);
  const closeDeleteModal = () => setDeleting(false);

  const updateList = async (name) => {
    await repo.updateList(listId, name);
    setUpdatedAt(repo.now());
    closeEditModal();
  };

  const deleteList = async () => {
    await repo.deleteList(listId);
    closeDeleteModal();
    window.location = "/lists";
  }

  const alert = message => {
    setAlertText(message);
    setTimeout(() => {
      setAlertText("");
    }, 1500);
  }

  const downloadCsv = (e) => {
    e.preventDefault();
    const content = generateCsv(items);
    const csv = new Blob([content], { type: "text/csv;charset=utf-8;" });
    const csvUrl = URL.createObjectURL(csv);
    const link = document.createElement("a");
    link.href = csvUrl;
    link.setAttribute("download", `${list.name}.csv`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);

    URL.revokeObjectURL(csvUrl);
  }

  return (
    <div className="container position-relative" role="list" aria-labelledby="list-name">
      {alertText && <div className="alert alert-warning alert-fixed">{alertText}</div>}
      <div className="row">
        <h1 id="list-name">{list.name}</h1>
      </div>
      <div className="row mb-3">
        <button className="btn btn-primary" type="button" onClick={editList}>
          Rename
        </button>
      </div>
      <div className="row mb-2">
        <p><strong>Note:</strong> The link to this list won't work for someone else or in another browser.</p>
      </div>
      {items.length > 0 && (
        <div className="row mb-2">
          <a href="" onClick={downloadCsv}>Download List</a>
        </div>
      )}
      {items.map(item => (
        <ListItem
          key={item.id}
          item={item}
          listId={list.id}
          onRemoved={() => alert("Item removed. Uncheck to undo.")}
          onAdded={() => alert("Item added")}
        />
      ))}
      <div className="row mt-4">
        <button className="btn btn-danger" onClick={() => setDeleting(true)}>
          Delete
        </button>
      </div>
      <ModalListForm
        open={editing}
        name={list.name}
        onClose={closeEditModal}
        onSubmit={updateList}
        submitButtonText="Update"
      />
      <Modal
        open={deleting}
        onClose={closeDeleteModal}
        title="Are You Sure?"
      >
        <div>
          <button className="btn btn-secondary" type="button" onClick={closeDeleteModal}>Cancel</button>
          <button className="btn btn-danger" type="button" onClick={deleteList}>Delete</button>
        </div>
      </Modal>
    </div>
  )
}

export { List };
