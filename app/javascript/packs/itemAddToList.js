import React from "react";
import ReactDOM from "react-dom";
import { repo } from "../lists/repo";
import { ItemAddToList} from "../lists/item-add-to-list";

/**
 * This is the pack that is booted on the item details page from
 * the _show_sidebar.html.erb partial.
**/
document.addEventListener('DOMContentLoaded', () => {
  repo.init();
  const root = document.getElementById("item-add-to-list-root");
  const documentId = root.getAttribute("attr-document-id");
  ReactDOM.render(<ItemAddToList documentId={documentId} />, root);
});
