export default {
  /** @type {ExportedHandlerFetchHandler<Env>} */
  async fetch(request, env, ctx) {
    return new Response("Server working");
  },
};
