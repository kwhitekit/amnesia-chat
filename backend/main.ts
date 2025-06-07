import { Hono } from "hono";
import { gqlRouter } from "./gql-router.ts";

const app = new Hono()
  .route("/graphql", gqlRouter);

Deno.serve({
  port: 3000,
}, app.fetch);
