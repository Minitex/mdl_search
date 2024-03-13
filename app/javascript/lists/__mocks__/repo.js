const repo = {
  createList: jest.fn().mockResolvedValue("mock createList response"),
  updateList: jest.fn().mockResolvedValue(undefined),
  deleteList: jest.fn().mockResolvedValue(undefined),
  loadLists: jest.fn().mockResolvedValue({
    "wizards-list-id": {
      "id": "wizards-list-id",
      "name": "Wizards",
      "count": 3,
      "selectedHash": {
        "snape": "snape",
        "scrimgeour": "scrimgeour",
        "dumbledore": "dumbledore"
      },
      "createdAt": 1705795282314,
      "updatedAt": 1705795282314
    },
    "muggles-list-id": {
      "id": "muggles-list-id",
      "name": "Muggles",
      "count": 2,
      "selectedHash": {
        "petunia": "petunia",
        "dudley": "dudley"
      },
      "createdAt": 1705795282314,
      "updatedAt": 1705795282314
    }
  }),
  loadList: jest.fn().mockResolvedValue({
    "id": "wizards-list-id",
    "name": "Wizards",
    "count": 3,
    "selectedHash": {
      "snape": "snape",
      "scrimgeour": "scrimgeour",
      "dumbledore": "dumbledore"
    },
    "createdAt": 1705795282314,
    "updatedAt": 1705795282314
  }),
  addToList: jest.fn().mockResolvedValue(null),
  removeFromList: jest.fn().mockResolvedValue(null),

  now: () => new Date().valueOf()
};

export { repo };
