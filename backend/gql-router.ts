import { ApolloServer } from "@apollo/server";
import { ApolloServerPluginLandingPageLocalDefault } from "@apollo/server/plugin/landingPage/default";
import { startServerAndCreateCloudflareWorkersHandler } from "@as-integrations/cloudflare-workers";
import { Hono } from "hono";

const typeDefs = `#graphql
  type Query {
    health: String!
  }
`;

const resolvers = {
  Query: {
    health: () => {
      return "ok";
    },
  },
};

const gqlServer = new ApolloServer({
  typeDefs,
  resolvers,
  introspection: true,
  plugins: [
    ApolloServerPluginLandingPageLocalDefault(),
  ],
});

const handler = startServerAndCreateCloudflareWorkersHandler(
  gqlServer as /// The type mismatch (actually imported from esm, but incorrectly expect from cjs)
  // deno-lint-ignore no-explicit-any
  any,
);
const gql_handler = (req: Request, ctx: unknown) =>
  handler(req, undefined, ctx);

export const gqlRouter = new Hono().all(
  "/",
  (c) => gql_handler(c.req.raw, c.var),
);
