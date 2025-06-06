import { Hono } from "hono";

const app = new Hono();

Deno.serve({
  port: 3000,
}, app.fetch);
