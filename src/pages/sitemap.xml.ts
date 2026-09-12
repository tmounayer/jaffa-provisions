import type { APIRoute } from 'astro';
// Add each new public page here. Keep the 404 page out of the sitemap.
const pages = ['/'];
export const GET: APIRoute = ({ site }) => new Response(
  `<?xml version="1.0" encoding="UTF-8"?><urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">${pages.map(path => `<url><loc>${new URL(path, site).href}</loc></url>`).join('')}</urlset>`,
  { headers: { 'Content-Type': 'application/xml' } },
);
