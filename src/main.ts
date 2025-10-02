import type { Server } from "http";
import { ValidationPipe } from "@nestjs/common";
import { NestFactory } from "@nestjs/core";
import { DocumentBuilder, SwaggerModule } from "@nestjs/swagger";
import { AppModule } from "./app.module";
import { DbService } from "./db/db.service";

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  // Enable CORS
  app.enableCors();

  app.useGlobalPipes(new ValidationPipe({ transform: true, whitelist: true }));
  //const config = app.get(ConfigService);
  const port = Number(process.env.PORT || 3000);

  // Apply the Prisma exception filter globally
  app.setGlobalPrefix("v6/reports");

  // Get PrismaService instance to handle graceful shutdown
  const prismaService = app.get(DbService);
  prismaService.enableShutdownHooks(app);

  // Configure Swagger
  const config = new DocumentBuilder()
    .setTitle("Topcoder Reports API")
    .setDescription(
      "The API for managing reports for Topgear and internal uses.",
    )
    .setVersion("6.0")
    .setBasePath("v6/reports")
    .addBearerAuth()
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup("/v6/reports/api-docs", app, document);

  const httpServer = app.getHttpAdapter().getHttpServer() as Server;

  // Request timeout (no activity on socket)
  httpServer.setTimeout(300_000); // 5 min

  // Optional but recommended when long requests + keep-alive are used:
  // keepAliveTimeout must be < headersTimeout
  httpServer.keepAliveTimeout = 295_000; // how long to keep idle keep-alive sockets
  httpServer.headersTimeout = 300_000; // max time to receive complete headers

  await app.listen(port);
  console.log(`Application is running on: ${await app.getUrl()}`);
  console.log(
    `Swagger docs available at: ${await app.getUrl()}/v6/reports/api-docs`,
  );
}
bootstrap().catch(console.error);
