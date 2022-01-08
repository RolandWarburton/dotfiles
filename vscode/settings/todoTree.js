export const todoTree = {
  "todo-tree.general.tags": [
    "BUG",
    "HACK",
    "STEP",
    "TASK",
    "FIXME",
    "TODO",
    "DONE",
    "SKIPPED",
    "ISSUE",
    "READ",
    "NOTE",
    "UPDATE",
    "QUESTION",
    "#",
    "##",
    "###",
    "GOAL",
    "breakpoint",
    "debugger",
  ],
  "todo-tree.filtering.excludeGlobs": [
    "**/node_modules",
    "**/Gemfile",
    "**/Gemfile.lock",
    "**/Rakefile",
    "**/*.rb",
    "**/*.sh",
    "**/dockerfile",
    "**/*.yaml",
  ],
  "todo-tree.highlights.customHighlight": {
    breakpoint: {
      icon: "flame",
      iconColour: "red",
      foreground: "#af002a",
      gutterIcon: true,
    },
    debugger: {
      icon: "flame",
      iconColour: "red",
      foreground: "#af002a",
      gutterIcon: true,
    },
    GOAL: {
      icon: "flame",
      background: "#fe7d71",
      iconColour: "red",
      foreground: "#af002a",
      gutterIcon: true,
    },
    TODO: {
      icon: "x",
      background: "#fe7d71",
      iconColour: "red",
      foreground: "#000000",
      gutterIcon: true,
    },
    UPDATE: {
      icon: "bell",
      background: "#c9ffe5",
      iconColour: "#c9ffe5",
      foreground: "#000000",
      gutterIcon: true,
    },
    QUESTION: {
      icon: "unverified",
      background: "#e77a85",
      iconColour: "#e77a85",
      foreground: "#000000",
      gutterIcon: true,
    },
    ISSUE: {
      type: "line",
      icon: "stop",
      background: "#fe7d71",
      iconColour: "red",
      foreground: "#000000",
      gutterIcon: true,
    },
    DONE: {
      icon: "check",
      background: "#3ec63e",
      iconColour: "#3ec63e",
      foreground: "#000000",
      gutterIcon: true,
    },
    SKIPPED: {
      icon: "hourglass",
      background: "yellow",
      iconColour: "yellow",
      foreground: "#000000",
      gutterIcon: true,
    },
    READ: {
      icon: "checklist",
      background: "#7cb9e8",
      iconColour: "#7cb9e8",
      foreground: "#000000",
      gutterIcon: true,
    },
    NOTE: {
      icon: "checklist",
      background: "#fff338",
      iconColour: "#fff338",
      foreground: "#000000",
      gutterIcon: true,
    },
    STEP: {
      type: "line",
      icon: "tasklist",
      background: "#00dea4",
      iconColour: "#00dea4",
      foreground: "#000000",
      gutterIcon: true,
    },
    TASK: {
      type: "line",
      icon: "tasklist",
      background: "#00dea4",
      iconColour: "#00dea4",
      foreground: "#000000",
      gutterIcon: true,
    },
    "#": {
      type: "line",
      foreground: "#000000",
      background: "#e0ff70",
    },
    "##": {
      type: "line",
      foreground: "#000000",
      background: "#ff97e3",
    },
    "###": {
      type: "line",
      foreground: "#000000",
      background: "#7bff89",
    },
  },
};
