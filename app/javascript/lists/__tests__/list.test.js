import React from "react";
import { fireEvent, render, waitFor, within } from "test-utils";
import { List } from "../list";
import { repo } from "../repo";

describe("List", () => {
  beforeEach(() => {
    jest.clearAllMocks();

    fetch.mockResolvedValueOnce({
      ok: true,
      json: () => Promise.resolve({
        items: [{
          id: "list-1-id",
          title: "List 1",
          description: "List 1 desc",
          collectionName: "ACME",
          thumbnailUrl: "/thumbnail-1",
          catalogUrl: "https://collection.mndigital.org/catalog/list-1"
        }, {
          id: "list-2-id",
          title: "List 2",
          description: "List 2 desc",
          collectionName: "ACME",
          thumbnailUrl: "/thumbnail-2",
          catalogUrl: "https://collection.mndigital.org/catalog/list-2"
        }, {
          id: "list-3-id",
          title: "List 3",
          description: "List 3 desc",
          collectionName: "ACME",
          thumbnailUrl: "/thumbnail-3",
          catalogUrl: "https://collection.mndigital.org/catalog/list-3"
        }],
        count: 3
      })
    });
  });

  const renderComponent = async () => {
    const queries = render(<List listId="wizards-list-id" />);
    await waitFor(() => expect(fetch).toHaveBeenCalled());
    return queries;
  };

  it("renders the list items", async () => {
    const { getAllByRole } = await renderComponent();

    expect(getAllByRole("listitem").length).toEqual(3);
  });

  it("the list can be deleted", async () => {
    const { getByRole } = await renderComponent();

    const deleteButton = getByRole("button", { name: "Delete" });
    fireEvent.click(deleteButton);
    const modalDialog = getByRole("dialog");
    const { getByRole: scopedGetByRole, getByText } = within(modalDialog);
    getByText("Are You Sure?");
    fireEvent.click(scopedGetByRole("button", { name: "Delete" }));

    await waitFor(() => expect(repo.deleteList).toHaveBeenCalled());
    expect(repo.deleteList).toHaveBeenCalledWith("wizards-list-id");
  });

  it("the list name can be updated", async () => {
    const { getByRole } = await renderComponent();

    const updateButton = getByRole("button", { name: "Rename" });
    fireEvent.click(updateButton);
    const modalDialog = getByRole("dialog");
    const { getByText } = within(modalDialog);
    getByText("Name Your List");

    const input = getByRole("textbox", { name: "List Name" });
    fireEvent.change(input, { target: { value: "Sorcerers" } });
    fireEvent.click(getByRole("button", { name: "Update" }));

    await waitFor(() => expect(repo.updateList).toHaveBeenCalled());
    expect(repo.updateList).toHaveBeenCalledWith("wizards-list-id", "Sorcerers");
  });
});
