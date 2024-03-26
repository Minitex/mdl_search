global.fetch = jest.fn(() => {
  return Promise.resolve({
    json: Promise.resolve({})
  });
});
