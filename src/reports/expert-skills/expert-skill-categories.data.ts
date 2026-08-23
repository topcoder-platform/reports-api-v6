/**
 * Visual tokens for Skill Statistics bubbles.
 * Category names/ids come from standardized-skills; these palettes are
 * assigned by hashing the category id so new catalog entries still render.
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
  "TerminalIcon",
  "RssIcon",
  "GlobeAltIcon",
  "ShieldCheckIcon",
  "CloudIcon",
  "RefreshIcon",
  "DuplicateIcon",
  "ChipIcon",
  "ChartBarIcon",
  "SparklesIcon",
  "ServerIcon",
  "PencilAltIcon",
  "CalculatorIcon",
  "CubeTransparentIcon",
  "MapIcon",
  "DesktopComputerIcon",
  "ClipboardCheckIcon",
  "DatabaseIcon",
  "DeviceMobileIcon",
  "ShareIcon",
  "WifiIcon",
  "ClipboardListIcon",
  "CodeIcon",
];

export type CategoryAppearance = {
  color: string;
  icon: string;
};

export function getCategoryAppearance(categoryId: string): CategoryAppearance {
  const hash = hashString(categoryId);

  return {
    color: CATEGORY_COLORS[hash % CATEGORY_COLORS.length],
    icon: CATEGORY_ICONS[hash % CATEGORY_ICONS.length],
  };
}

export function normalizeCategoryName(value: string): string {
  return value
    .toLowerCase()
    .replace(/&/g, "and")
    .replace(/[^a-z0-9]+/g, " ")
    .trim();
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
