// to run
// pnpm tsx scripts/eslintIsIgnored.ts ../app/layout.tsx

import { ESLint } from 'eslint';

const isFileIgnored = async (file) => {
  const eslint = new ESLint({ overrideConfigFile: './eslint.config.js' });
  const isIgnored = await eslint.isPathIgnored(file);

  const config = await eslint.calculateConfigForFile(file);

  console.log({ isIgnored, config });
};

(async () => {
  const [_2, __2, arg2] = process.argv;

  await isFileIgnored(arg2);
})();
