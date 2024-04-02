import localforage from "localforage";

const LIST_LIMIT = 50;

const repo = {
  /**
   * Initializes the IndexedDB configuration.
   */
  init: function() {
    localforage.config({
      name: "MDL Lists",
    });
  },

  /**
   * Loads a specific list from the DB.
   * @param {string} listId - The ID of the list to load.
   * @return {Promise<Object>} The list object.
   */
  loadList: function(listId) {
    return localforage.getItem(listId);
  },

  /**
   * Loads all lists from the DB.
   * @return {Promise<Object>} An object containing all lists.
   */
  loadLists: async function() {
    const lists = {};
    await localforage.iterate((value, key, _i) => {
      if (typeof value === "object" && value !== null) {
        lists[key] = value;
      }
    })
    return lists;
  },

  /**
   * Creates a new list in the DB.
   * @param {string} name - The name of the new list.
   * @return {Promise<Object>} The created list object.
   */
  createList: async function(name) {
    if (!name) { return; }
    const id = window.crypto.randomUUID();
    const timestamp = this.now();
    const list = {
      id,
      name,
      count: 0,
      selectedHash: {},
      createdAt: timestamp,
      updatedAt: timestamp
    };
    return await localforage.setItem(id, list);
  },

  /**
   * Updates the name of an existing list.
   * @param {string} id - The ID of the list to update.
   * @param {string} name - The new name for the list.
   * @return {Promise<Object>} The updated list object.
   */
  updateList: async function(id, name) {
    if (!name) { return; }
    const list = await this.loadList(id);

    list.name = name;
    list.updatedAt = this.now();
    return await localforage.setItem(id, list);
  },

  /**
   * Deletes a list.
   * @param {string} id - The ID of the list to delete.
   * @return {Promise<void>}
   */
  deleteList: function(id) {
    return localforage.removeItem(id);
  },

  /**
   * Adds an item to a list.
   * @param {string} itemId - The ID of the item to add.
   * @param {string} listId - The ID of the list to which the item is added.
   * @return {Promise<Object>} The updated list object.
   */
  addToList: async function(itemId, listId) {
    const list = await this.loadList(listId);
    if (list.count >= LIST_LIMIT) {
      throw new Error(`list is at capacity (${LIST_LIMIT} items)`);
    }

    list.selectedHash[itemId] = itemId;
    list.count = Object.keys(list.selectedHash).length;
    return await localforage.setItem(listId, list);
  },

  /**
   * Removes an item from a list.
   * @param {string} itemId - The ID of the item to remove.
   * @param {string} listId - The ID of the list from which the item is removed.
   * @return {Promise<Object>} The updated list object.
   */
  removeFromList: async function(itemId, listId) {
    const list = await this.loadList(listId);
    delete list.selectedHash[itemId];
    list.count = Object.keys(list.selectedHash).length;
    return await localforage.setItem(listId, list);
  },

  /**
   * Gets the ID of the currently selected list
   * @returns {Promise<string>}
   */
  getSelectedList: async function() {
    return localforage.getItem('selected-list');
  },

  /**
   * @param {string} listId - The ID of the list being selected
   */
  setSelectedList: async function(listId) {
    if (listId) {
      return await localforage.setItem('selected-list', listId);
    } else {
      return await localforage.removeItem('selected-list');
    }
  },

  /**
   * Returns the current timestamp.
   * @return {number} The current timestamp (unix time).
   */
  now: () => {
    return new Date().valueOf();
  }
};

export { repo, LIST_LIMIT };
