import fs from "fs";

import { copilot } from "./settings/copilot";
import { core } from "./settings/core";
import { tabnine } from "./settings/tabnine";
import { theme } from "./settings/theme";
import { todoTree } from "./settings/todoTree";
import { vim } from "./settings/vim";
import { cspell } from "./settings/languages/cspell";
import { dart } from "./settings/languages/dart";
import { ruby } from "./settings/languages/ruby";
import { typescript } from "./settings/languages/typescript";

const settings = {
  ...copilot,
  ...core,
  ...tabnine,
  ...theme,
  ...todoTree,
  ...vim,
  ...cspell,
  ...dart,
  ...ruby,
  ...typescript,
};

fs.writeFileSync("settings.json", JSON.stringify(settings, null, 2));
