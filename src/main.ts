import { ValidationPipe } from "@nestjs/common";
import { NestFactory } from "@nestjs/core";
import { DocumentBuilder, SwaggerModule } from "@nestjs/swagger";
//import { ConfigService } from '@nestjs/config';
import { AppModule } from "./app.module";

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.useGlobalPipes(new ValidationPipe({ transform: true, whitelist: true }));
  //const config = app.get(ConfigService);
  const port = Number(process.env.PORT || 3000);

  // Configure Swagger
  const config = new DocumentBuilder()
    .setTitle("TopCoder Lookup API")
    .setDescription(
      "The API for managing lookup data like countries, devices, and educational institutions.",
    )
    .setVersion("6.0")
    .setBasePath("v6/lookups")
    .addBearerAuth()
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup("api-docs", app, document);

  await app.listen(port);
  console.log(`Application is running on: ${await app.getUrl()}`);
  console.log(`Swagger docs available at: ${await app.getUrl()}/api-docs`);
}
bootstrap().catch(console.error);
