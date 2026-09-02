/**
 * Visual tokens for Skill Statistics bubbles.
 * Category names/ids come from standardized-skills. Icons are Material Symbols
 * Rounded ligatures (https://fonts.google.com/icons?icon.style=Rounded).
 * Known catalog names map to Figma icons/colors; unknown entries still hash by id.
 */
const CATEGORY_COLORS = [
  "#1B4F72",
  "#3D8B8F",
  "#5B9BD5",
  "#5EB3C4",
  "#1A3D3D",
  "#2D4A3E",
  "#4A5D4A",
  "#3D7EA6",
  "#2C5F8A",
  "#7EB8C4",
  "#2C4A6E",
  "#3D5C5C",
  "#6B7C4A",
  "#2D5A8A",
  "#5A8A8A",
  "#4EC4C4",
  "#5A8A9A",
  "#4A9A9A",
  "#3D6A8A",
  "#5EB8B0",
  "#3D5A6E",
  "#4A6A7A",
];

const CATEGORY_ICONS = [
  "terminal",
  "cell_tower",
  "language",
  "shield_locked",
  "desktop_cloud",
  "refresh",
  "layers",
  "memory",
  "bar_chart",
  "psychology",
  "dns",
  "design_services",
  "calculate",
  "database",
  "map",
  "install_desktop",
  "fact_check",
  "settings_cell",
  "hub",
  "devices",
  "assignment",
  "code",
  "sync",
];

export type CategoryAppearance = {
  color: string;
  icon: string;
};

export function normalizeCategoryName(value: string): string {
  return value
    .toLowerCase()
    .replace(/&/g, "and")
    .replace(/[^a-z0-9]+/g, " ")
    .trim();
}

const NAMED_CATEGORY_APPEARANCE: Array<[string[], CategoryAppearance]> = [
  [["Programming and Development"], { color: "#1B4F72", icon: "terminal" }],
  [["Web Development"], { color: "#7EB8C4", icon: "language" }],
  [
    ["Networking and Telecommunications"],
    { color: "#5EB3C4", icon: "cell_tower" },
  ],
  [["Cybersecurity"], { color: "#5B9BD5", icon: "shield_locked" }],
  [
    [
      "Software Development Lifecycle (SDLC)",
      "Software Development Lifecycle",
      "SDLC",
    ],
    { color: "#1A3D3D", icon: "refresh" },
  ],
  [["Cloud Computing"], { color: "#2C4A6E", icon: "desktop_cloud" }],
  [["Operating Systems"], { color: "#3D7EA6", icon: "memory" }],
  [["DevOps and Automation"], { color: "#2D4A3E", icon: "sync" }],
  [["Data Analysis and Big Data"], { color: "#2C5F8A", icon: "bar_chart" }],
  [["Virtualization"], { color: "#3D7EA6", icon: "layers" }],
  [["Databases and Data Warehousing"], { color: "#1B4F72", icon: "dns" }],
  [["Mathematics and Statistics"], { color: "#6B7C4A", icon: "calculate" }],
  [["Database Management"], { color: "#7EB8C4", icon: "database" }],
  [
    ["Geospatial Information Systems (GIS)", "Geospatial Information Systems"],
    { color: "#3D6A8A", icon: "map" },
  ],
  [["Machine Learning and AI"], { color: "#5EB8B0", icon: "psychology" }],
  [
    ["User Experience Design and Multimedia", "UX Design and Multimedia"],
    { color: "#3D5C5C", icon: "design_services" },
  ],
  [
    ["Hardware and Systems Administration"],
    { color: "#4EC4C4", icon: "install_desktop" },
  ],
  [["Mobile App Development"], { color: "#5A8A8A", icon: "settings_cell" }],
  [
    ["Software Testing and Quality Assurance", "Software Testing and QA"],
    { color: "#2C5F8A", icon: "fact_check" },
  ],
  [["Blockchain"], { color: "#2C4A6E", icon: "hub" }],
  [["IoT (Internet of Things)"], { color: "#3D8B8F", icon: "devices" }],
  [["Project Management"], { color: "#3D7EA6", icon: "assignment" }],
  [["Scripting and Automation"], { color: "#5B9BD5", icon: "code" }],
];

const CATEGORY_APPEARANCE_BY_NAME: Record<string, CategoryAppearance> =
  Object.fromEntries(
    NAMED_CATEGORY_APPEARANCE.flatMap(([names, appearance]) =>
      names.map((name) => [normalizeCategoryName(name), appearance]),
    ),
  );

export function getCategoryAppearance(
  categoryId: string,
  categoryName?: string,
): CategoryAppearance {
  const mapped = categoryName
    ? CATEGORY_APPEARANCE_BY_NAME[normalizeCategoryName(categoryName)]
    : undefined;

  if (mapped) {
    return mapped;
  }

  const hash = hashString(categoryId);

  return {
    color: CATEGORY_COLORS[hash % CATEGORY_COLORS.length],
    icon: CATEGORY_ICONS[hash % CATEGORY_ICONS.length],
  };
}

export const MIN_CATEGORY_SIZE = 3;
export const MAX_CATEGORY_SIZE = 10;

export function normalizeCategorySizes(wins: number[]): number[] {
  if (!wins.length) {
    return [];
  }

  const roots = wins.map((value) => Math.sqrt(Math.max(value, 0)));
  const minRoot = Math.min(...roots);
  const maxRoot = Math.max(...roots);

  if (maxRoot <= minRoot) {
    return wins.map(() => (MIN_CATEGORY_SIZE + MAX_CATEGORY_SIZE) / 2);
  }

  return roots.map((root) => {
    const size =
      MIN_CATEGORY_SIZE +
      ((MAX_CATEGORY_SIZE - MIN_CATEGORY_SIZE) * (root - minRoot)) /
        (maxRoot - minRoot);

    return Number(size.toFixed(1));
  });
}

function hashString(value: string): number {
  let hash = 2166136261;

  for (let index = 0; index < value.length; index += 1) {
    hash ^= value.charCodeAt(index);
    hash = Math.imul(hash, 16777619);
  }

  return hash >>> 0;
}
