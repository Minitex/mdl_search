import React from "react";
import ReactDOM from "react-dom";
import { CreateList } from "../lists/create-list";
import { eventTracking } from "../lists/event-tracking";
import { repo, LIST_LIMIT } from "../lists/repo";

/**
 * Applies list functionality in the context of a search results page;
 * for instance, on URL path /catalog
 */
document.addEventListener("DOMContentLoaded", () => {
  repo.init();
  loadLists();
  attachListeners();
  const createListNode = document.getElementById("create-list-root");
  ReactDOM.render(
    <CreateList onCreate={addNewList} className="btn-primary" />,
    createListNode
  );
});

/**
 * Adds a new list and updates the UI accordingly.
 * @param {Object} list - The new list to add.
 */
async function addNewList(list) {
  createListOptions({ [list.id]: list }, listItem => {
    listItem.setAttribute("selected", "selected");
  });
  await enableAddToList(list.id);
}

/**
 * Loads lists from the repository and updates the UI.
 */
async function loadLists() {
  const lists = await repo.loadLists();
  const selectedListId = await repo.getSelectedList();
  createListOptions(lists, async listItem => {
    if (selectedListId && listItem.value === selectedListId) {
      listItem.setAttribute("selected", "selected");
      await enableAddToList(selectedListId);
    }
  });
}

/**
 * Creates and displays options for each list in the UI.
 * @param {Object} lists - An object containing lists.
 * @param {Function} [customizer] - An optional function to customize each list item.
 */
function createListOptions(lists, customizer) {
  const listsSelect = document.getElementById("selectList");
  for (const [listId, list] of Object.entries(lists)) {
    const listItem = document.createElement("option");
    listItem.value = listId;
    listItem.textContent = listOptionLabel(list);
    if (customizer) {
      customizer(listItem);
    }
    listsSelect.appendChild(listItem);
  }
}

/**
 * Returns a formatted label for a list option.
 * @param {Object} list - The list to create a label for.
 * @return {string} The formatted label.
 */
function listOptionLabel(list) {
  return `${list.name} (${list.count} ${list.count == 1 ? "item" : "items"})`;
}

/**
 * Attaches event listeners to handle changes in the UI.
 */
function attachListeners() {
  document.addEventListener("change", async event => {
    if (event.target.matches("input.list-eligible[type='checkbox']")) {
      await addOrRemoveItem(event);
    }
    if (event.target.matches("#selectList")) {
      setCurrentList(event);
    }
  });
}

/**
 * Handles adding or removing an item from a list.
 * @param {Event} event - The event object.
 */
async function addOrRemoveItem(event) {
  const input = event.target;
  const documentId = input.getAttribute("data-document-id");
  const listId = input.getAttribute("data-list-id");
  if (input.checked) {
    await repo.addToList(documentId, listId);
    eventTracking.itemAdded(documentId);
  } else {
    await repo.removeFromList(documentId, listId);
    eventTracking.itemRemoved(documentId);
  }
  const list = await repo.loadList(listId);
  onListUpdated(list);
}

/**
 * Apply any necessary updates to the DOM in response to an
 * update to the given list.
 * @param {object} list
 */
function onListUpdated(list) {
  updateSelectOptionText(list);
  applyCheckboxState(list)
}

/**
 * Updates the text of a select option based on the updated list.
 * @param {object} list - The list to update.
 */
function updateSelectOptionText(list) {
  const listId = list.id;
  const option = document.querySelector(`#selectList option[value="${listId}"]`);
  option.textContent = listOptionLabel(list);
}

/**
 * Limit the number of items a list can have. No-op if the limit
 * is not yet reached
 * @param {object} list
 */
function applyCheckboxState(list) {
  const limitReached = list.count >= LIST_LIMIT;

  document
    .querySelectorAll("input.list-eligible[type='checkbox']")
    .forEach(chbx => {
      chbx.setAttribute("data-list-id", list.id);
      const itemId = chbx.getAttribute("data-document-id");
      const isChecked = itemId in list.selectedHash;
      chbx.checked = isChecked;

      const label = chbx.parentNode;
      const labelText = label.querySelector(".js-label-text");

      if (limitReached && !isChecked) {
        chbx.setAttribute("disabled", "disabled");
        label.setAttribute("title", `List can have a max of ${LIST_LIMIT} items`);
        labelText.textContent = "Can't add more";
      } else {
        chbx.removeAttribute("disabled");
        label.removeAttribute("title");
        labelText.textContent = isChecked ? "Added to List" : "Add to List";
      }
    });
}

/**
 * Sets the current list based on the user's selection.
 * @param {Event} event - The event object.
 */
function setCurrentList(event) {
  const selectedListId = event.target.value;
  if (selectedListId) {
    enableAddToList(selectedListId);
  } else {
    disableAddToList();
  }
}

/**
 * Enables the addition of items to a specified list.
 * @param {string} listId - The ID of the list to enable addition for.
 */
async function enableAddToList(listId) {
  let list = await repo.loadList(listId);
  applyCheckboxState(list);
  // show the checkboxes
  document
    .querySelectorAll(".document-add-to-list")
    .forEach(node => node.classList.remove("hide"));
  await repo.setSelectedList(listId);
}

/**
 * Disables the addition of items to any list.
 */
async function disableAddToList() {
  document
    .querySelectorAll(".document-add-to-list")
    .forEach(node => node.classList.add("hide"));
  await repo.setSelectedList(null);
}
