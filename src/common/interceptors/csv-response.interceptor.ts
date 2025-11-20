import {
  CallHandler,
  ExecutionContext,
  Injectable,
  NestInterceptor,
} from "@nestjs/common";
import { Request, Response } from "express";
import { Observable } from "rxjs";
import { map } from "rxjs/operators";
import { CsvSerializer } from "../csv/csv-serializer";

@Injectable()
export class CsvResponseInterceptor implements NestInterceptor {
  constructor(private readonly csvSerializer: CsvSerializer) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<unknown> {
    const httpContext = context.switchToHttp();
    const request = httpContext.getRequest<Request>();
    const response = httpContext.getResponse<Response>();

    if (!this.shouldReturnCsv(request)) {
      return next.handle();
    }

    return next.handle().pipe(
      map((data) => {
        const csv = this.csvSerializer.serialize(data);
        response.setHeader("Content-Type", "text/csv; charset=utf-8");
        return csv;
      }),
    );
  }

  private shouldReturnCsv(request: Request) {
    const header = request.headers.accept;
    if (!header) {
      return false;
    }

    const values = Array.isArray(header) ? header.join(",") : header;
    return values
      .split(",")
      .map((value) => value.split(";")[0]?.trim().toLowerCase())
      .some((value) => value === "text/csv");
  }
}
