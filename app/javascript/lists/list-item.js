import React, { useState } from "react";
import { repo } from "./repo";

const ListItem = ({ item, listId, onRemoved, onAdded }) => {
  const [deleted, setDeleted] = useState(false);

  const addOrRemoveItem = async (shouldRemove) => {
    if (shouldRemove) {
      await repo.removeFromList(item.id, listId);
    } else {
      await repo.addToList(item.id, listId);
    }
  };

  const handleChange = (event) => {
    const shouldRemove = event.target.checked;
    setDeleted(shouldRemove);
    shouldRemove ? onRemoved() : onAdded()
    addOrRemoveItem(shouldRemove);
  }

  return (
    <div className={`row mb-2 ${deleted ? "list-item-deleted" : ""}`} key={item.id}>
      <div className="col col-1">
        <form className="form">
          <div className="form-group">
            <input id={`remove-${item.id}`} onChange={handleChange} type="checkbox" />
            <label htmlFor={`remove-${item.id}`}>
              <small>Remove from list</small>
            </label>
          </div>
        </form>
      </div>
      <div className="col col-2">
        <img className="list-item-thumbnail" src={item.thumbnailUrl} />
      </div>
      <div className="col">
        <h5 className="item-title">
          <a href={item.catalogUrl}>{item.title}</a>
        </h5>
        <h6 className="">{item.collectionName}</h6>
        <p className="item-desc">{item.description}</p>
      </div>
    </div>
  )
};

export { ListItem };
