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

  it("maps known category names to Figma icons regardless of id", () => {
    expect(
      getCategoryAppearance(
        "481b5ebc-2fe6-45ed-a90c-736936d458d7",
        "Programming & Development",
      ),
    ).toEqual({
      color: "#1B4F72",
      icon: "TerminalIcon",
    });
    expect(getCategoryAppearance("unused-id", "Web Development")).toEqual({
      color: "#7EB8C4",
      icon: "GlobeAltIcon",
    });
    expect(
      getCategoryAppearance(
        "unused-id",
        "Software Development Lifecycle (SDLC)",
      ).icon,
    ).toBe("RefreshIcon");
    expect(
      getCategoryAppearance("unused-id", "UX Design and Multimedia").icon,
    ).toBe("PencilAltIcon");
  });

  it("hashes unknown categories by id so new catalog entries still render", () => {
    const first = getCategoryAppearance(
      "481b5ebc-2fe6-45ed-a90c-736936d458d7",
      "Test Cat QA 1",
    );
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
