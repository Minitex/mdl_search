import React, { useEffect, useState } from "react";
import { repo } from "./repo";
import { CreateList } from "./create-list";

/**
 * This is the component that handles adding an item to a list
 * in the context of the item details page; for instance, from
 * a URL path such as /catalog/:id
**/
const ItemAddToList = ({ documentId }) => {
  const [updatedAt, setUpdatedAt] = useState(repo.now());
  const [lists, setLists] = useState([]);
  const [alertText, setAlertText] = useState("");

  useEffect(() => {
    (async () => {
      const listsResp = await repo.loadLists();
      const lists = [];
      for (const [_, list] of Object.entries(listsResp)) {
        lists.push(list);
      }
      setLists(lists);
    })();
  }, [documentId, updatedAt]);

  const addOrRemove = async (event, listId) => {
    event.target.checked ? await add(listId) : await remove(listId);

    update();
  };

  const add = async listId => {
    try {
      await repo.addToList(documentId, listId);
      alert("Item added");
    } catch ({ message }) {
      alert(message);
    }
  }

  const remove = async listId => {
    await repo.removeFromList(documentId, listId);
    alert("Item removed");
  }

  const alert = message => {
    setAlertText(message);
    setTimeout(() => {
      setAlertText("");
    }, 1500);
  }

  const update = () => setUpdatedAt(repo.now());

  return (
    <div className="item-add-to-list mt-3">
      {alertText && <div className="alert alert-warning alert-fixed">{alertText}</div>}
      <CreateList className="btn-secondary w-100" onCreate={update} />
      <div className="lists-available mt-2">
        {lists.map(list => (
          <div key={list.id} className="form-check form-check-inline w-100">
            <input
              id={`list-${list.id}`}
              className="form-check-input"
              type="checkbox"
              checked={documentId in list.selectedHash}
              onChange={(e) => addOrRemove(e, list.id)}
            />
            <label
              className="form-check-label d-flex justify-content-between w-100"
              htmlFor={`list-${list.id}`}
            >
              <span>{list.name}</span>
              <span>
                <small className="text-muted">
                  {` ${list.count} item${list.count === 1 ? "" : "s"}`}
                </small>
              </span>
            </label>
          </div>
        ))}
      </div>
    </div>
  );
};

export { ItemAddToList };
