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

app.all('/*', async (c) => {

  const request = new Request(c.req.raw);
  const url = new URL(request.url);
  //console.log(`proxying req to url: ${url.pathname} to hostname: ${c.env.AUTH0_EDGE_LOCATION}`);

  url.hostname = c.env.AUTH0_EDGE_LOCATION;
  request.headers.set('cname-api-key', c.env.CNAME_API_KEY);

  return await fetch(url, request);
})

/*
app.get('/', async (c) => {
  return c.text(`federation migration. cname-api-key: ${c.env.CNAME_API_KEY}, edge-location: ${c.env.AUTH0_EDGE_LOCATION}`);
});
*/

// noinspection JSUnusedGlobalSymbols
export default app;
