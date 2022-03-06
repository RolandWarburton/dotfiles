export const vim = {
  "vim.useSystemClipboard": true,
  "vim.hlsearch": true,
  "vim.handleKeys": {
    // ctrl + f
    "C-f": false,
    // ignore ctrl + w in normal mode (close window),
    "<C-w>": false,
    // ignore ctrl + d in normal mode (down a page),
    "<C-d>": false,
    // copy
    "C-c": false,
    // paste
    "C-v": false,
    // cut
    "C-x": false,
    // undo
    "C-u": false,
    // redo
    "C-r": false,
  },
  "vim.normalModeKeyBindings": [
    {
      // ctrl + n: turn off highlighting
      before: ["<C-n>"],
      commands: [":nohl"],
    },
    {
      // map B to beginning of line
      before: ["B"],
      after: ["^"]
    },
    {
      // map E to beginning of line
      before: ["E"],
      after: ["$"]
    }
  ],
};
