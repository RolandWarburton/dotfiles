export const core = {
  // Set the zoom level
  "window.zoomLevel": -1,
  // How to handle untrusted files
  "security.workspace.trust.untrustedFiles": "open",
  // When opening files with quick open, do not preview them (just open them)
  "workbench.editor.enablePreview": true,
  // Controls how suggestions are pre-selected when showing the suggest list
  // OPTIONS: first, recentlyUsed
  "editor.suggestSelection": "first",
  // Controls how whitespace is rendered
  "editor.renderWhitespace": "all",
  // Controls how much syntax highlighting is used
  "json.maxItemsComputed": 50000,
  // In the file tree, highlight files when searching there
  "workbench.list.keyboardNavigation": "highlight",
  // When searching open in a new editor tab
  "search.mode": "newEditor",
  // When searching use the previous search to populate the search box
  "search.searchEditor.reusePriorSearchConfiguration": true,
  // Smooth caret animation
  "editor.cursorSmoothCaretAnimation": true,
  // Set the cursor style
  "editor.cursorStyle": "block-outline",
  // Show indentation
  "editor.guides.indentation": true,
  // Set wordwrap settings for editor
  "editor.wordWrap": "off",
  // Set wordwrap settings for diffs
  "diffEditor.wordWrap": "off",
  // Render param names
  "editor.inlayHints.enabled": false,
  // Set the side the minimap is on
  "editor.minimap.side": "right",
  // Do not restore the windows when reopening
  "window.restoreWindows": "none",
  // Minimap scale
  "editor.minimap.scale": 1,
  // How should sidebar items be shown (Don't reveal in sidebar (or use don't scroll))
  "explorer.autoReveal": "focusNoScroll",
  // File tree indentation
  "workbench.tree.indent": 24,
  // Auto tag rename
  "editor.linkedEditing": true,
  // Helps make source maps work sometimes
  "debug.javascript.unmapMissingSources": true,
  // Disable squashing folders with no files in them
  "explorer.compactFolders": false,
  // Do not watch these files
  "eslint.validate": ["javascript"],
  "files.watcherExclude": {
    "**/.git/objects/**": true,
    "**/.git/subtree-cache/**": true,
    "**/node_modules/**": true,
  },
  // What page should be shown when starting up
  // OPTIONS: none, welcomePage, readme, newUntitledFile
  "workbench.startupEditor": "none",
  // Show code suggestions as you type
  "editor.inlineSuggest.enabled": true,
  // Ruler at 100 chars
  "editor.rulers": [100],
  // Run git fetch passively
  "git.autofetch": true,
  // bracket pair colors
  "editor.guides.bracketPairs": false,
  // Indent block highlighting color settings
  "blockhighlight.background": ["200", "100", "255", ".06"],
  // ## Indentation Rules
  "editor.detectIndentation": false,
  "editor.tabSize": 2,
  "editor.insertSpaces": true,
  // ## Code Formatting
  "editor.formatOnSave": true,
  "editor.formatOnPaste": false,
  "editor.formatOnType": false,
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
  },
  "typescript.format.enable": false, // ISSUE is this breaking formatting TS?
  "[typescriptreact]": {
    "editor.defaultFormatter": "vscode.typescript-language-features",
  },
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
  },
  "[json]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
  },
  "[yaml]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
  },
  "[markdown]": {
    "editor.defaultFormatter": "yzhang.markdown-all-in-one",
  },
  "[scss]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
  },
  "[css]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
  },
  "[html]": {
    "editor.defaultFormatter": "vscode.html-language-features",
  },
  "[jsonc]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
  },
  "[dockerfile]": {
    "editor.defaultFormatter": "ms-azuretools.vscode-docker",
  },
  "[ruby]": {
    "editor.defaultFormatter": "rebornix.ruby",
  },
  // ## Code Linting
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true,
  },
  "markdownlint.config": {
    MD030: false,
  },
};
