// To change anything on the site, edit this file. Text in quotes is safe to change.
export interface SiteContent {
  brandName: string; tagline: string; headline: string; intro: string[];
  heroImage: string; heroImageAlt: string;
  sections: { title: string; body: string[]; image?: string; imageAlt?: string }[];
  contact: { email?: string; instagram?: string; phone?: string; address?: string; hours?: string };
  footerNote: string;
  emailSignup?: { enabled: boolean; heading: string; formUrl: string };
  theme: { primaryColor: string; accentColor: string; font: string };
  seo: { title: string; description: string };
  labels: { skipToContent: string; story: string; home: string; signup: string; contact: string; instagram: string };
  links: { home: string; story: string }; favicon: string;
  notFound: { title: string; headline: string; body: string };
}
// Starting copy and imagery: replace these as the offering takes shape.
export const site: SiteContent = {
  brandName: 'Jaffa Provisions',
  tagline: 'Good things take time.',
  headline: 'A little more\nat the table.',
  intro: [
    'A love of good food. A generous table. Something new in the making.',
    'We’re taking our time with the details. We look forward to sharing what comes next.',
  ],
  heroImage: '/images/jaffa-pantry.jpg',
  heroImageAlt: 'Oranges, olives and torn bread on a sunlit terracotta table.',
  sections: [
    { title: 'It starts with\nsomething simple.', body: [
      'The first piece of bread. A bowl passed around. The conversation that keeps everyone at the table a little longer.',
      'Jaffa Provisions is a new idea rooted in these everyday pleasures. We’re still shaping what it will become, with good food and a spirit of welcome at its heart.',
    ] },
    { title: 'Room for\nwhat’s next.', body: [
      'For now, we’re gathering ideas and making plans. This is a small beginning, with plenty of room to grow.',
      'Come back soon. There’s more to share.',
    ], image: '/images/jaffa-pantry.jpg', imageAlt: 'A simple spread of citrus, bread and olives in afternoon light.' },
  ],
  contact: {},
  footerNote: 'Good food. Good company. More good things to come.',
  emailSignup: { enabled: false, heading: 'A note from our table.', formUrl: '' },
  theme: { primaryColor: '#243b2b', accentColor: '#a94024', font: 'Georgia, serif' },
  seo: { title: 'Jaffa Provisions — Good things take time', description: 'A love of good food, a generous table, and something new in the making. Meet Jaffa Provisions.' },
  labels: { skipToContent: 'Skip to content', story: 'Our beginnings', home: 'Back to home', signup: 'Keep me posted', contact: 'At the table', instagram: 'Instagram' },
  links: { home: '/', story: '/#our-beginnings' }, favicon: '/favicon.svg',
  notFound: { title: 'Page not found — Jaffa Provisions', headline: 'A little off the beaten path.', body: 'We couldn’t find that page. There’s a place for you back at our table.' },
};
