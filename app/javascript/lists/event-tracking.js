const eventTracking = {
  listCreated: () => {
    track("create_list");
  },

  listDeleted: () => {
    track("delete_list");
  },

  listDownloaded: () => {
    track("download_list");
  },

  itemAdded: (documentId) => {
    track("add_item_to_list", { document_id: documentId });
  },

  itemRemoved: (documentId) => {
    track("remove_item_from_list", { document_id: documentId });
  }
};

const track = (eventName, details = {}) => {
  if (typeof window.gtag === 'undefined') { return; }

  window.gtag("event", eventName, details);
}

export { eventTracking };
