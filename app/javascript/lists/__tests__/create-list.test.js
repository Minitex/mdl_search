import React from "react";
import { render, fireEvent, waitFor } from "test-utils";
import { CreateList } from "../create-list";
import { repo } from "../repo";

describe("CreateList", () => {
  beforeEach(() => jest.clearAllMocks());

  it("opens the modal form when 'Create New List' button is clicked", async () => {
    const onCreate = jest.fn();
    const { getByRole } = render(<CreateList onCreate={onCreate} />);
    getByRole("button", { name: "Create New List" }).click();
    const input = getByRole("textbox", { name: "List Name" });
    fireEvent.change(input, { target: { value: "Wizards"} });
    getByRole("button", { name: "Create List" }).click();
    await waitFor(() => expect(repo.createList).toHaveBeenCalled());
    expect(repo.createList).toHaveBeenCalledWith("Wizards");
    expect(onCreate).toHaveBeenCalledWith("mock createList response");
  });

  it("can be canceled", () => {
    const { getByRole, queryByRole } = render(<CreateList />);
    getByRole("button", { name: "Create New List" }).click();
    const input = getByRole("textbox", { name: "List Name" });
    fireEvent.change(input, { target: { value: "Muggles" } });
    getByRole("button", { name: "Cancel" }).click();
    expect(repo.createList).not.toHaveBeenCalled();
    expect(queryByRole("textbox", { name: "List Name" })).toBeNull();
  });
});
