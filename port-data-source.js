const fs = require("fs");

module.exports = {
  writeFile: async function ({ filePath, contents }) {
    return await fs.promises.writeFile(filePath, contents);
  },
};
