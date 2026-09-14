// @ts-check
import { defineConfig } from 'astro/config';
export default defineConfig({
  site: 'https://jaffaprovisions.com',
  output: 'static',
  // Pin the tsconfig so Vite/rolldown never auto-discovers one in a parent
  // directory (e.g. when this repo is checked out as a nested Git worktree).
  vite: { tsconfig: './tsconfig.json' },
});
