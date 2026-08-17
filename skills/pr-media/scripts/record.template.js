// Mall för browser_run_code_unsafe. Kopiera till
// <workspace>/.playwright-mcp/pr-media/<slug>/record.js, fyll i toppen
// och demo(), kör med filename satt till den absoluta sökvägen.
async (page) => {
  const OUT = '/home/hector/work/HRM/features/SLUG/.playwright-mcp/pr-media/SLUG';
  const BASE_URL = 'https://localhost:56866';
  const NEEDS_LOGIN = true;
  const KUNDINSTANS = 'FLEX1';

  // Det tittaren ska se. Sidan är redan på Home (eller BASE_URL) när demo() börjar.
  async function demo(p) {
    await p.waitForTimeout(800);
    // await p.getByRole('link', { name: '...' }).click();
    // await p.getByRole('textbox', { name: '...' }).pressSequentially('...', { delay: 50 });
    // await p.waitForTimeout(700);
    await p.waitForTimeout(1500);
  }

  // Forms-login i Flex.Net.Web. Spelas in men klipps bort med demoStartSec.
  async function login(p) {
    await p.goto(BASE_URL + '/', { waitUntil: 'networkidle' });
    if (!(await p.locator('#LoginButton').count())) return;
    const inst = p.locator('input[name=Kundinstans]');
    if ((await inst.count()) && !(await inst.inputValue())) await inst.fill(KUNDINSTANS);
    await p.fill('input[name=Anvandarnamn]', 'DEMO.CEO');
    await p.fill('input[name=Losenord]', '');
    await p.click('#LoginButton');
    // Redirecten till Home sker via JS efter att sidan laddat, networkidle räcker inte.
    await p.waitForURL((u) => !u.pathname.startsWith('/Login'), { timeout: 45000 });
    await p.waitForLoadState('networkidle');
  }

  const browser = page.context().browser();
  const size = { width: 1280, height: 720 };

  // En enda context. Login via storageState från en separat context ger cookies men
  // ingen fungerande SignalR-ström (chatbotens svar kommer aldrig), så login spelas
  // in och klipps bort: to-gif.sh <webm> demo.gif <demoStartSec>.
  const ctx = await browser.newContext({
    viewport: size,
    ignoreHTTPSErrors: true, // dev-certet på localhost
    recordVideo: { dir: OUT, size },
  });
  // Nova: cookie-bannern överlever inte storageState, göm den i klippet.
  await ctx.addInitScript(() => {
    const style = document.createElement('style');
    style.textContent = '#CookieBanner { display: none !important; }';
    document.addEventListener('DOMContentLoaded', () => document.head.appendChild(style));
  });

  const p = await ctx.newPage();
  const t0 = Date.now();
  let video, demoStartSec = 0;
  try {
    if (NEEDS_LOGIN) {
      await login(p);
      await p.waitForTimeout(500);
      demoStartSec = (Date.now() - t0) / 1000;
    } else {
      await p.goto(BASE_URL + '/', { waitUntil: 'networkidle' });
    }
    await demo(p);
    await p.screenshot({ path: OUT + '/final.png' });
  } finally {
    for (const other of ctx.pages()) if (other !== p) await other.close();
    video = await p.video().path();
    await ctx.close(); // skriver klart videon
  }
  return { video, demoStartSec, final: OUT + '/final.png' };
}
