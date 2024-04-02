import React from "react";
import { fireEvent, render, waitFor } from "test-utils";
import { ItemAddToList } from "../item-add-to-list";
import { repo } from "../repo";

describe("ItemAddToList", () => {
  beforeEach(() => jest.clearAllMocks());

  describe("when the current document is in one of the lists", () => {
    it("can be removed", async () => {
      const { getByRole } = render(<ItemAddToList documentId={"dumbledore"} />);
      await waitFor(() => expect(repo.loadLists).toHaveBeenCalled());
      const checkbox = getByRole("checkbox", { name: /Wizards/i, checked: true });
      fireEvent.click(checkbox);
      await waitFor(() => {
        expect(repo.removeFromList).toHaveBeenCalledWith(
          "dumbledore",
          "wizards-list-id"
        );
      });
    });
  });

  describe("when the current document is not in one of the lists", () => {
    it("can be added", async () => {
      const { getByRole } = render(<ItemAddToList documentId={"flitwick"} />);
      await waitFor(() => expect(repo.loadLists).toHaveBeenCalled());
      const checkbox = getByRole("checkbox", { name: /Wizards/i, checked: false });
      fireEvent.click(checkbox);
      await waitFor(() => {
        expect(repo.addToList).toHaveBeenCalledWith(
          "flitwick",
          "wizards-list-id"
        );
      });
    });
  });
});
