import React, { useEffect, useState } from "react";
import { repo } from "./repo";
import { CreateList } from "./create-list";
import { eventTracking } from "./event-tracking";

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
      eventTracking.itemAdded(documentId);
    } catch ({ message }) {
      alert(message);
    }
  }

  const remove = async listId => {
    await repo.removeFromList(documentId, listId);
    alert("Item removed");
    eventTracking.itemRemoved(documentId);
  }

  const alert = message => {
    setAlertText(message);
    setTimeout(() => {
      setAlertText("");
    }, 1500);
  }

  const update = () => setUpdatedAt(repo.now());

  return (
    <section className="item-add-to-list mt-3">
      <h2>Add to List</h2>
      {alertText && <div className="alert alert-warning alert-fixed">{alertText}</div>}
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
              <span
                className="d-inline-block text-truncate"
                style={{maxWidth: "130px"}}
                title={list.name}
              >{list.name}</span>
              <span>
                <small className="text-muted">
                  {` ${list.count} item${list.count === 1 ? "" : "s"}`}
                </small>
              </span>
            </label>
          </div>
        ))}
      </div>
      <CreateList className="btn-secondary w-100 mt-2" onCreate={update} />
    </section>
  );
};

export { ItemAddToList };
