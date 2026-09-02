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
      icon: "terminal",
    });
    expect(getCategoryAppearance("unused-id", "Web Development")).toEqual({
      color: "#7EB8C4",
      icon: "language",
    });
    expect(
      getCategoryAppearance(
        "unused-id",
        "Software Development Lifecycle (SDLC)",
      ).icon,
    ).toBe("cloud_sync");
    expect(
      getCategoryAppearance("unused-id", "DevOps and Automation").icon,
    ).toBe("rule_settings");
    expect(
      getCategoryAppearance("unused-id", "UX Design and Multimedia").icon,
    ).toBe("design_services");
    expect(getCategoryAppearance("unused-id", "Project Management").icon).toBe(
      "assignment",
    );
  });

  it("gives each known category a unique icon", () => {
    const names = [
      "Programming and Development",
      "Web Development",
      "Networking and Telecommunications",
      "Cybersecurity",
      "Software Development Lifecycle (SDLC)",
      "Cloud Computing",
      "Operating Systems",
      "DevOps and Automation",
      "Data Analysis and Big Data",
      "Virtualization",
      "Databases and Data Warehousing",
      "Mathematics and Statistics",
      "Database Management",
      "Geospatial Information Systems (GIS)",
      "Machine Learning and AI",
      "User Experience Design and Multimedia",
      "Hardware and Systems Administration",
      "Mobile App Development",
      "Software Testing and Quality Assurance",
      "Blockchain",
      "IoT (Internet of Things)",
      "Project Management",
      "Scripting and Automation",
    ];
    const icons = names.map(
      (name) => getCategoryAppearance("unused-id", name).icon,
    );

    expect(new Set(icons).size).toBe(names.length);
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
    expect(first.icon).toMatch(/^[a-z0-9_]+$/);
  });

  it("normalizes sizes on sqrt(wins) into the bubble range", () => {
    const sizes = normalizeCategorySizes([10000, 100, 4]);

    expect(sizes[0]).toBe(MAX_CATEGORY_SIZE);
    expect(sizes[sizes.length - 1]).toBe(MIN_CATEGORY_SIZE);
    expect(sizes[1]).toBeGreaterThan(MIN_CATEGORY_SIZE);
    expect(sizes[1]).toBeLessThan(MAX_CATEGORY_SIZE);
  });
});
