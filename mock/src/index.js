import endpoints from "./endpoints";

const headers = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization",
};

export default {
  /** @type {ExportedHandlerFetchHandler<Env>} */
  async fetch(request, env, ctx) {
    const url = new URL(request.url);
    const endpoint = url.pathname.replace("/api/3/", "").replace("/api/", "");

    const themesMatch = endpoint.match(/^subjects\/themes\/([^/]+)$/);
    if (themesMatch) {
      return Response.json(
        endpoints["subjects/themes"](decodeURIComponent(themesMatch[1])),
        {
          headers: headers,
        },
      );
    }

    if (Object.keys(endpoints).includes(endpoint)) {
      return Response.json(endpoints[endpoint](), {
        headers: headers,
      });
    }
    return new Response("Server working", { headers: headers });
  },
};
