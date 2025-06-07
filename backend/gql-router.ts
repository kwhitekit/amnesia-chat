import { ApolloServer } from "@apollo/server";
import { ApolloServerPluginLandingPageLocalDefault } from "@apollo/server/plugin/landingPage/default";

const typeDefs = `#graphql
  type Query {
    example: String!
  }
`;

const resolvers = {
  Query: {
    example: () => {
      return "Hello world!";
    },
  },
};

export const gqlServer = new ApolloServer({
  typeDefs,
  resolvers,
  introspection: true,
  plugins: [
    ApolloServerPluginLandingPageLocalDefault(),
  ],
});
