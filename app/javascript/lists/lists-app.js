import React from "react";
import { MyLists } from "./my-lists";
import { List } from "./list";

const ListsApp = ({ listId }) => {
  return (
    listId ? <List listId={listId} /> : <MyLists />
  );
}

export { ListsApp };
