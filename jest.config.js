const path = require("node:path");
const javascriptRoot = path.join("app", "javascript");

module.exports = {
  testEnvironment: "jsdom",
  roots: [javascriptRoot],
  moduleDirectories: [
    "node_modules",
    javascriptRoot
  ],
  setupFilesAfterEnv: ['<rootDir>/jest.setup.js'],
};
