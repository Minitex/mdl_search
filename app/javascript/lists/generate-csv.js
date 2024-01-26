const headersByAttribute = {
  title: "Title",
  description: "Description",
  collectionName: "Collection",
  thumbnailUrl: "Thumbnail",
  catalogUrl: "URL"
};

const generateCsv = (items) => {
  let content = "";
  const headers = Object.keys(items[0]).map(k => headersByAttribute[k]);
  content += headers.join(",") + "\r\n";

  items.forEach(item => {
    const row = Object.values(item).map(sanitize).join(",");
    content += row + "\r\n";
  });

  return content;
};

const sanitize = (value) => {
  if (value.includes(',') || value.includes('\n') || value.includes('"')) {
    return `"${value.replace(/"/g, '""')}"`; // Escape double-quotes and enclose in double-quotes
  }
  return value;
};

export { generateCsv };
