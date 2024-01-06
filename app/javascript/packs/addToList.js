import React from "react";
import ReactDOM from "react-dom";
import { CreateList } from "../lists/create-list";
import { repo } from "../lists/repo";

/**
 * Initializes the application by setting up the repository, loading lists, and
 * attaching event listeners. Renders the CreateList React component once the
 * DOM is fully loaded.
 */
document.addEventListener("DOMContentLoaded", async () => {
  repo.init();
  loadLists();
  attachListeners();
  const createListNode = document.getElementById("create-list-root");
  ReactDOM.render(
    <CreateList onCreate={addNewList} />,
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
  enableAddToList(list.id);
}

/**
 * Loads lists from the repository and updates the UI.
 */
async function loadLists() {
  const lists = await repo.loadLists();
  createListOptions(lists);
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
  } else {
    await repo.removeFromList(documentId, listId);
  }
  await updateSelectOptionText(listId);
}

/**
 * Updates the text of a select option based on the updated list.
 * @param {string} listId - The ID of the list to update.
 */
async function updateSelectOptionText(listId) {
  const list = await repo.loadList(listId);
  const option = document.querySelector(`#selectList option[value="${listId}"]`);
  option.textContent = listOptionLabel(list);
}

/**
 * Sets the current list based on the user's selection.
 * @param {Event} event - The event object.
 */
function setCurrentList(event) {
  const selectedList = event.target.value;
  if (selectedList) {
    enableAddToList(selectedList);
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
  document
    .querySelectorAll("input.list-eligible[type='checkbox']")
    .forEach(node => {
      node.setAttribute("data-list-id", listId);
      const itemId = node.getAttribute("data-document-id");
      node.checked = !!list.selectedHash[itemId];
    });
  document
    .querySelectorAll(".document-add-to-list")
    .forEach(node => node.classList.remove("hide"));
}

/**
 * Disables the addition of items to any list.
 */
function disableAddToList() {
  document
    .querySelectorAll(".document-add-to-list")
    .forEach(node => node.classList.add("hide"));
}
