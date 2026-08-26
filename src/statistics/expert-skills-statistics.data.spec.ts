import {
  MAX_CATEGORY_SIZE,
  MIN_CATEGORY_SIZE,
  getCategoryAppearance,
  normalizeCategoryName,
  normalizeCategorySizes,
} from "./expert-skills-statistics.data";

describe("expert-skills-statistics.data", () => {
  it("normalizes catalog names for lookup", () => {
    expect(normalizeCategoryName("Programming & Development")).toBe(
      normalizeCategoryName("Programming and Development"),
    );
  });

  it("assigns a stable color and icon from the category id", () => {
    const first = getCategoryAppearance("481b5ebc-2fe6-45ed-a90c-736936d458d7");
    const second = getCategoryAppearance(
      "481b5ebc-2fe6-45ed-a90c-736936d458d7",
    );

    expect(first).toEqual(second);
    expect(first.color).toMatch(/^#[0-9A-F]{6}$/i);
    expect(first.icon).toMatch(/Icon$/);
  });

  it("normalizes sizes on sqrt(wins) into the bubble range", () => {
    const sizes = normalizeCategorySizes([10000, 100, 4]);

    expect(sizes[0]).toBe(MAX_CATEGORY_SIZE);
    expect(sizes[sizes.length - 1]).toBe(MIN_CATEGORY_SIZE);
    expect(sizes[1]).toBeGreaterThan(MIN_CATEGORY_SIZE);
    expect(sizes[1]).toBeLessThan(MAX_CATEGORY_SIZE);
  });
});
