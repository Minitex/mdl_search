import React from "react";
import { fireEvent, render, waitFor } from "test-utils";
import { ListItem } from "../list-item";
import { repo } from "../repo";

describe("ListItem", () => {
  beforeEach(() => jest.clearAllMocks());

  it("can be removed from the list and re-added", async () => {
    const onRemoved = jest.fn();
    const onAdded = jest.fn();
    const item = {
      id: "an-item-id",
      thumbnailUrl: "/thumb",
      catalogUrl: "/catalog",
      title: "An Item",
      collectionName: "Items 'R Us",
      description: "A nondescript thing"
    };
    const { getByRole } = render(
      <ListItem
        listId={"a-list-id"}
        item={item}
        onRemoved={onRemoved}
        onAdded={onAdded}
      />
    );
    let checkbox = getByRole(
      "checkbox",
      { name: "Remove from list", checked: false }
    );
    fireEvent.click(checkbox);
    await waitFor(() => {
      expect(repo.removeFromList).toHaveBeenCalledWith(
        "an-item-id",
        "a-list-id"
      );
    });
    expect(onRemoved).toHaveBeenCalled();
    expect(getByRole("listitem")).toHaveClass("list-item-deleted");

    checkbox = getByRole(
      "checkbox",
      { name: "Remove from list", checked: true }
    );
    fireEvent.click(checkbox);
    await waitFor(() => {
      expect(repo.addToList).toHaveBeenCalledWith(
        "an-item-id",
        "a-list-id"
      );
    });
    expect(onAdded).toHaveBeenCalled();
    expect(getByRole("listitem")).not.toHaveClass("list-item-deleted");
  });
});
