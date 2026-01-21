/**
 * Generate styled CLI screenshots for GitHub README
 *
 * Renders ANSI terminal output as styled HTML screenshots
 * Usage: npx tsx scripts/generate-cli-screenshots.ts
 */

import { chromium } from 'playwright';
import { writeFileSync, mkdirSync, existsSync } from 'fs';
import { execSync } from 'child_process';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ASSETS_DIR = join(__dirname, '..', 'assets');

// Terminal color map (ANSI to CSS)
const COLORS = {
  // Squads purple gradient
  purple: '#a855f7',
  pink: '#ec4899',
  cyan: '#22d3ee',
  green: '#22c55e',
  yellow: '#eab308',
  red: '#ef4444',
  gray: '#6b7280',
  white: '#ffffff',
  // Background
  bg: '#0f0f0f',
  bgLight: '#1a1a1a',
};

// Commands to screenshot
const COMMANDS = [
  { name: 'status', cmd: 'squads status', description: 'Squad overview' },
  { name: 'dash', cmd: 'squads dash', description: 'Full dashboard' },
  { name: 'status-verbose', cmd: 'squads status engineering -v', description: 'Squad detail' },
];

/**
 * Convert ANSI escape codes to HTML spans
 */
function ansiToHtml(text: string): string {
  // Map ANSI codes to CSS classes
  const ansiMap: Record<string, string> = {
    // Squads gradient colors (38;2;R;G;B format)
    '38;2;168;85;247': 'color: #a855f7;',
    '38;2;187;123;251': 'color: #bb7bfb;',
    '38;2;216;125;250': 'color: #d87dfa;',
    '38;2;237;118;222': 'color: #ed76de;',
    '38;2;245;114;172': 'color: #f572ac;',
    '38;2;251;113;133': 'color: #fb7185;',
    '38;2;75;85;99': 'color: #6b7280;',
    '38;2;6;182;212': 'color: #22d3ee;',
    '38;2;16;185;129': 'color: #22c55e;',
    '38;2;234;179;8': 'color: #eab308;',
    '38;2;255;255;255': 'color: #ffffff;',
    '1': 'font-weight: bold;',
    '0': '',
  };

  let result = text;

  // Replace ANSI sequences with spans
  result = result.replace(/\[([0-9;]+)m/g, (match, codes) => {
    const codeList = codes.split(';');
    const fullCode = codes;

    if (fullCode === '0') return '</span>';

    const style = ansiMap[fullCode] || '';
    if (style) return `<span style="${style}">`;

    // Handle 38;2;R;G;B format
    if (codeList[0] === '38' && codeList[1] === '2') {
      const r = codeList[2];
      const g = codeList[3];
      const b = codeList[4];
      return `<span style="color: rgb(${r},${g},${b});">`;
    }

    return '';
  });

  return result;
}

/**
 * Generate HTML page for terminal output
 */
function generateTerminalHtml(title: string, output: string): string {
  const htmlOutput = ansiToHtml(output);

  return `
<!DOCTYPE html>
<html>
<head>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      background: #0f0f0f;
      padding: 20px;
      font-family: 'JetBrains Mono', 'Fira Code', monospace;
    }
    .terminal {
      background: linear-gradient(135deg, #1a1a1a 0%, #0f0f0f 100%);
      border-radius: 12px;
      border: 1px solid #333;
      overflow: hidden;
      max-width: 800px;
    }
    .terminal-header {
      background: #1f1f1f;
      padding: 12px 16px;
      display: flex;
      align-items: center;
      gap: 8px;
      border-bottom: 1px solid #333;
    }
    .terminal-dot {
      width: 12px;
      height: 12px;
      border-radius: 50%;
    }
    .dot-red { background: #ff5f56; }
    .dot-yellow { background: #ffbd2e; }
    .dot-green { background: #27c93f; }
    .terminal-title {
      color: #666;
      font-size: 13px;
      margin-left: 8px;
    }
    .terminal-body {
      padding: 20px;
      color: #e5e7eb;
      font-size: 13px;
      line-height: 1.6;
      white-space: pre;
      overflow-x: auto;
    }
    span { display: inline; }
  </style>
</head>
<body>
  <div class="terminal">
    <div class="terminal-header">
      <div class="terminal-dot dot-red"></div>
      <div class="terminal-dot dot-yellow"></div>
      <div class="terminal-dot dot-green"></div>
      <span class="terminal-title">${title}</span>
    </div>
    <div class="terminal-body">${htmlOutput}</div>
  </div>
</body>
</html>`;
}

async function main() {
  console.log('\n📸 Generating CLI screenshots...\n');

  // Ensure assets directory exists
  if (!existsSync(ASSETS_DIR)) {
    mkdirSync(ASSETS_DIR, { recursive: true });
  }

  const browser = await chromium.launch();
  const context = await browser.newContext({
    viewport: { width: 900, height: 600 },
    deviceScaleFactor: 2,
  });

  for (const { name, cmd, description } of COMMANDS) {
    try {
      console.log(`  Capturing: ${cmd}`);

      // Run command and capture output
      const output = execSync(cmd, {
        encoding: 'utf-8',
        cwd: process.env.HOME + '/agents-squads/hq',
        env: { ...process.env, FORCE_COLOR: '1' }
      });

      // Generate HTML
      const html = generateTerminalHtml(description, output);
      const htmlPath = join(ASSETS_DIR, `${name}.html`);
      writeFileSync(htmlPath, html);

      // Screenshot with Playwright
      const page = await context.newPage();
      await page.setContent(html);
      await page.waitForTimeout(100);

      // Get terminal element size
      const terminal = await page.$('.terminal');
      if (terminal) {
        const box = await terminal.boundingBox();
        if (box) {
          await page.screenshot({
            path: join(ASSETS_DIR, `${name}.png`),
            clip: { x: box.x - 10, y: box.y - 10, width: box.width + 20, height: box.height + 20 },
          });
        }
      }

      await page.close();
      console.log(`  ✓ ${name}.png`);
    } catch (error) {
      console.error(`  ✗ ${name}: ${error}`);
    }
  }

  await browser.close();
  console.log('\n✅ Done!\n');
}

main().catch(console.error);
