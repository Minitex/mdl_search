import React from "react";
import ReactDOM from "react-dom";
import { ListsApp } from "../lists/lists-app";
import { repo } from "../lists/repo";

document.addEventListener("DOMContentLoaded", () => {
  repo.init();
  const rootNode = document.getElementById("lists-root");
  const listId = rootNode.getAttribute("data-list-id");
  ReactDOM.render(
    <ListsApp listId={listId} />,
    rootNode,
  );
});
