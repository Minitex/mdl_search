import React from "react";
import { fireEvent, render, waitFor, within } from "test-utils";
import { MyLists } from "../my-lists";
import { repo } from "../repo";

describe("MyLists", () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  const renderComponent = async () => {
    const queries = render(<MyLists />);
    await waitFor(() => expect(repo.loadLists).toHaveBeenCalled());
    return queries;
  };

  it("displays your saved lists", async () => {
    const { getAllByRole } = await renderComponent();

    const lists = getAllByRole("listitem");
    expect(lists.length).toEqual(2);

    const { getByText: gbt1 } = within(lists[0]);
    const link1 = gbt1("Wizards");
    expect(link1).toHaveAttribute("href", "/lists/wizards-list-id");
    gbt1("3 items");

    const { getByText: gbt2 } = within(lists[1]);
    const link2 = gbt2("Muggles");
    expect(link2).toHaveAttribute("href", "/lists/muggles-list-id");
    gbt2("2 items");
  });

  it("supports creating a list", async () => {
    const { getByRole } = await renderComponent();

    const createListButton = getByRole("button", { name: "Add List" });
    fireEvent.click(createListButton);
    const modalDialog = getByRole("dialog");
    const { getByText } = within(modalDialog);
    getByText("Name Your List");
    const input = getByRole("textbox", { name: "List Name" });
    fireEvent.change(input, { target: { value: "Quiddich Players" } });
    fireEvent.click(getByRole("button", { name: "Create" }));

    await waitFor(() => expect(repo.createList).toHaveBeenCalled());
    expect(repo.createList).toHaveBeenCalledWith("Quiddich Players");
  });
});
