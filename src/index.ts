import {Hono} from 'hono';

interface Env {
  Bindings: {
    CNAME_API_KEY: string;
    AUTH0_EDGE_LOCATION: string;
  };
}

const app = new Hono<Env>();

app.onError((err, c) => {
  console.log(`stack trace: ${err.stack}`);
  return c.text(`Internal Server Error: ${err.message}`, 500);
});

app.get('/', async (c) => {
  return c.text(`federation migration. cname-api-key: ${c.env.CNAME_API_KEY}, edge-location: ${c.env.AUTH0_EDGE_LOCATION}`);
});

// noinspection JSUnusedGlobalSymbols
export default app;
