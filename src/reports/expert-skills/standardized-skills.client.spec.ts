import {
  BadGatewayException,
  InternalServerErrorException,
} from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { Test, TestingModule } from "@nestjs/testing";
import { StandardizedSkillsClient } from "./standardized-skills.client";

const API_BASE_URL = "https://api.example.test";
const CATEGORIES_URL = `${API_BASE_URL}/v5/standardized-skills/categories?disablePagination=true&sortBy=name`;

describe("StandardizedSkillsClient", () => {
  let client: StandardizedSkillsClient;
  const configValues: Record<string, string | undefined> = {
    TOPCODER_API_URL_BASE: API_BASE_URL,
  };
  const mockConfigService = {
    get: jest.fn((key: string, defaultValue?: string) => {
      return configValues[key] ?? defaultValue;
    }),
  };
  const fetchMock = jest.fn();
  const originalFetch = global.fetch;

  beforeEach(async () => {
    fetchMock.mockReset();
    mockConfigService.get.mockClear();
    Object.keys(configValues).forEach((key) => {
      delete configValues[key];
    });
    configValues.TOPCODER_API_URL_BASE = API_BASE_URL;
    global.fetch = fetchMock as unknown as typeof fetch;

    const moduleRef: TestingModule = await Test.createTestingModule({
      providers: [
        StandardizedSkillsClient,
        { provide: ConfigService, useValue: mockConfigService },
      ],
    }).compile();

    client = moduleRef.get<StandardizedSkillsClient>(StandardizedSkillsClient);
  });

  afterEach(() => {
    global.fetch = originalFetch;
  });

  it("fetches categories from the standardized-skills catalog", async () => {
    fetchMock.mockResolvedValue({
      ok: true,
      json: () =>
        Promise.resolve([
          {
            id: "481b5ebc-2fe6-45ed-a90c-736936d458d7",
            name: "Programming and Development",
          },
          { id: "  ", name: "Ignored" },
          {
            id: "481b5ebc-2fe6-45ed-a90c-736936d458d7",
            name: "Duplicate",
          },
        ]),
    });

    await expect(client.fetchCategories()).resolves.toEqual([
      {
        id: "481b5ebc-2fe6-45ed-a90c-736936d458d7",
        name: "Programming and Development",
      },
    ]);
    expect(fetchMock).toHaveBeenCalledWith(CATEGORIES_URL, {
      headers: { Accept: "application/json" },
    });
  });

  it("reads wrapped category payloads", async () => {
    fetchMock.mockResolvedValue({
      ok: true,
      json: () =>
        Promise.resolve({
          categories: [
            {
              id: "1f5ed3e8-8d22-44ea-b75d-ea85147a04da",
              name: "Scripting and Automation",
            },
          ],
        }),
    });

    await expect(client.fetchCategories()).resolves.toEqual([
      {
        id: "1f5ed3e8-8d22-44ea-b75d-ea85147a04da",
        name: "Scripting and Automation",
      },
    ]);
  });

  it("throws when the catalog request fails", async () => {
    fetchMock.mockResolvedValue({
      ok: false,
      status: 401,
    });

    await expect(client.fetchCategories()).rejects.toBeInstanceOf(
      BadGatewayException,
    );
  });

  it("throws when TOPCODER_API_URL_BASE is not configured", async () => {
    delete configValues.TOPCODER_API_URL_BASE;

    await expect(client.fetchCategories()).rejects.toBeInstanceOf(
      InternalServerErrorException,
    );
    expect(fetchMock).not.toHaveBeenCalled();
  });
});
