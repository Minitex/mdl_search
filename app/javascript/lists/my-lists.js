import React, { useState, useEffect } from "react";
import { repo } from "./repo";
import { CreateList } from "./create-list";

const MyLists = () => {
  const [lists, setLists] = useState({});
  const [dirtiedAt, setDirtiedAt] = useState(repo.now());

  const loadLists = async () => {
    const myLists = await repo.loadLists();
    if (myLists) {
      setLists(myLists);
    }
  };

  useEffect(() => {
    loadLists();
  }, [dirtiedAt]);

  const onCreateList = async () => {
    setDirtiedAt(repo.now());
  }

  return (
    <div className="container">
      <h1>My Lists</h1>
      <div className="row">
        <div className="col">
          <p>
            <strong>Note:</strong> You won't see lists created in another browser here. To view those lists, open the browser you used when creating them.
          </p>
          <CreateList onCreate={onCreateList} className="btn-primary" />
        </div>
      </div>
      <div className="row mt-3" role="list">
        {Object.entries(lists).map(([id, list]) => {
          return (
            <div key={id} className="mb-3 col-xs-12 col-lg-6" role="listitem">
              <div className="card">
                <div className="card-body">
                  <h4 className="card-title" aria-label={list.name}>
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
