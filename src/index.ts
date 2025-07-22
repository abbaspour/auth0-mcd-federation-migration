import {Context, Hono} from 'hono';

/**
 * Environment variables interface for the worker
 * 
 * CNAME_API_KEY: API key for the Auth0 custom domain
 * AUTH0_EDGE_LOCATION: Hostname of the backend Auth0 edge location
 * NEW_SP_DOMAIN: Domain for the new service provider where SAML responses should be redirected
 */
interface Env {
  Bindings: {
    CNAME_API_KEY: string;
    AUTH0_EDGE_LOCATION: string;
    NEW_SP_DOMAIN: string;
  };
}

const app = new Hono<Env>();

app.onError((err, c) => {
  console.log(`stack trace: ${err.stack}`);
  return c.text(`Internal Server Error: ${err.message}`, 500);
});

async function proxy(c: Context<Env>) : Promise<Response> {
  const request = new Request(c.req.raw);
  const url = new URL(request.url);
  url.hostname = c.env.AUTH0_EDGE_LOCATION;
  request.headers.set('cname-api-key', c.env.CNAME_API_KEY);
  return await fetch(url, request);
}

// Handle POST /login/callback specifically for SAML responses
app.post('/login/callback', async (c) => {
  const formData = await c.req.formData();
  const samlResponse = formData.get('SAMLResponse');
  
  // If no SAMLResponse is present, proxy the request as usual
  if (!samlResponse) {
    return proxy(c);
  }
  
  // If SAMLResponse is present, create an auto-submitting form to the new domain
  const relayState = formData.get('RelayState');
  const newDomain = c.env.NEW_SP_DOMAIN;
  
  // Create HTML form that auto-submits to the new domain
  const html = `
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <title>Redirecting...</title>
    </head>
    <body onload="document.forms[0].submit()">
      <form method="post" action="https://${newDomain}/login/callback?connection=saml-federation-connection">
        <input type="hidden" name="SAMLResponse" value="${samlResponse}" />
        ${relayState ? `<input type="hidden" name="RelayState" value="${relayState}" />` : ''}
        <noscript>
          <p>JavaScript is disabled. Please click the button below to continue.</p>
          <input type="submit" value="Continue" />
        </noscript>
      </form>
    </body>
    </html>
  `;
  
  return c.html(html);
});

app.all('/*', async (c) => {
  return proxy(c);
})

/*
app.get('/', async (c) => {
  return c.text(`federation migration. cname-api-key: ${c.env.CNAME_API_KEY}, edge-location: ${c.env.AUTH0_EDGE_LOCATION}`);
});
*/

// noinspection JSUnusedGlobalSymbols
export default app;
