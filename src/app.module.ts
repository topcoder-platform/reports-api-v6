import { MiddlewareConsumer, Module, NestModule } from "@nestjs/common";
import { ConfigModule } from "@nestjs/config";
import { ReportsModule } from "./reports/reports.module";
import { DbModule } from "./db/db.module";
import { AuthMiddleware } from "./auth/auth.middleware";
import { HealthModule } from "./health/health.module";

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    DbModule,
    ReportsModule,
    HealthModule,
  ],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    // Apply the AuthMiddleware to all routes in the application.
    consumer.apply(AuthMiddleware).forRoutes("*");
  }
}
