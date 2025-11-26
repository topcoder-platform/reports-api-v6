import { multiValueArrayFilter } from "./filtering";

describe("multiValueArrayFilter", () => {
  it("returns empty include/exclude arrays for an empty input", () => {
    expect(multiValueArrayFilter([])).toEqual({ include: [], exclude: [] });
  });

  it("returns empty include/exclude arrays for undefined input", () => {
    expect(multiValueArrayFilter(undefined)).toEqual({
      include: [],
      exclude: [],
    });
  });

  it("splits include values", () => {
    expect(multiValueArrayFilter(["12345", "67890"])).toEqual({
      include: ["12345", "67890"],
      exclude: [],
    });
  });

  it("splits exclude values", () => {
    expect(multiValueArrayFilter(["!12345", "!67890"])).toEqual({
      include: [],
      exclude: ["12345", "67890"],
    });
  });

  it("splits mixed include and exclude values", () => {
    expect(multiValueArrayFilter(["12345", "!67890", "11111"])).toEqual({
      include: ["12345", "11111"],
      exclude: ["67890"],
    });
  });

  it("removes the exclusion prefix when present", () => {
    expect(multiValueArrayFilter(["!abc"])).toEqual({
      include: [],
      exclude: ["abc"],
    });
  });
});
