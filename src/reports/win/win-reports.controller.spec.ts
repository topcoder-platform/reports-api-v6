import { INestApplication, ValidationPipe } from "@nestjs/common";
import { Test } from "@nestjs/testing";
import { DbModule } from "../../db/db.module";
import { DbService } from "../../db/db.service";
import { AuthUserLike } from "../../auth/permissions.util";
import { WinReportsModule } from "./win-reports.module";

describe("WIN endpoint", () => {
  let app: INestApplication;
  let url: string;
  let authUser: AuthUserLike | undefined;
  const db = { query: jest.fn() };

  beforeAll(async () => {
    const module = await Test.createTestingModule({ imports: [DbModule, WinReportsModule] })
      .overrideProvider(DbService).useValue(db).compile();
    app = module.createNestApplication();
    app.setGlobalPrefix("v6/reports");
    app.use((req, _res, next) => { req.authUser = authUser; next(); });
    app.useGlobalPipes(new ValidationPipe({ transform: true, whitelist: true }));
    await app.listen(0, "127.0.0.1");
    url = `${await app.getUrl()}/v6/reports/WIN`;
  });

  afterAll(async () => { await app.close(); });

  beforeEach(() => {
    db.query.mockReset().mockResolvedValue([{ data: [], total: 0 }]);
    authUser = { isMachine: true, scopes: ["reports:win"] };
  });

  it.each([
    { isMachine: true, scopes: ["reports:win"] },
    { isMachine: false, scopes: "openid reports:win" },
    { roles: ["Administrator"] },
    { role: "Topcoder Talent Manager" },
  ])("allows the requested scope or human role: %j", async (user) => {
    authUser = user;
    const response = await fetch(url);
    expect(response.status).toBe(200);
    expect(await response.json()).toEqual({ data: [], total: 0, page: 1, perPage: 100 });
    expect(db.query).toHaveBeenCalledWith(expect.any(String), [null, 100, 0]);
  });

  it.each([
    undefined,
    { roles: ["Project Manager"] },
    { scopes: ["reports:all"] },
    { isMachine: true, roles: ["Administrator"] },
    { isMachine: true, scopes: ["reports:win-other"] },
  ])("denies callers without WIN access: %j", async (user) => {
    authUser = user;
    expect((await fetch(url)).status).toBe(user ? 403 : 401);
    expect(db.query).not.toHaveBeenCalled();
  });

  it.each(["page=0", "page=1.5", "perPage=101", "projectId=1%20OR%201=1", "projectId=9223372036854775808"])(
    "rejects invalid query %s before reading data", async (query) => {
      expect((await fetch(`${url}?${query}`)).status).toBe(400);
      expect(db.query).not.toHaveBeenCalled();
    },
  );

  it("binds filters and preserves totals on an empty later page", async () => {
    db.query.mockResolvedValue([{ data: [], total: 7 }]);
    const response = await fetch(`${url}?projectId=9007199254740993&page=3&perPage=10`);
    expect(await response.json()).toEqual({ data: [], total: 7, page: 3, perPage: 10 });
    expect(db.query).toHaveBeenCalledWith(expect.any(String), ["9007199254740993", 10, 20]);
  });
});
