import React, { useState } from "react";

const ListForm = ({ name, onSubmit, onCancel, submitButtonText }) => {
  const [listName, setListName] = useState(null);

  const handleSubmit = (e) => {
    e.preventDefault();
    onSubmit(listName);
  }

  const handleChange = (e) => {
    setListName(e.target.value);
  }

  return (
    <div className="list-form">
      <form onSubmit={handleSubmit} className="form">
        <div className="form-group">
          <label className="sr-only" htmlFor="list-name">List Name</label>
          <input
            type="text"
            className="form-control list-form-control"
            name="list-name"
            onChange={handleChange}
            defaultValue={name}
          />
        </div>
        <div className="form-actions">
          <button type="button" onClick={onCancel} className="btn btn-secondary">Cancel</button>
          <button type="submit" className="btn btn-primary">{submitButtonText}</button>
        </div>
      </form>
    </div>
  )
}

export { ListForm }
