module.exports = {
  root: true,
  env: {
    node: true,
    es2022: true,
    commonjs: true,
  },
  extends: [
    'eslint:recommended',
    'plugin:node/recommended',       // Node.js best practices
    'plugin:security/recommended',   // Security vulnerability detection
  ],
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',            // ESM (change to 'commonjs' if using require())
  },
  plugins: ['node', 'security'],
  rules: {
    // Node.js
    'node/no-unsupported-features/es-syntax': 'off', // Allow modern ES syntax
    'node/no-missing-import': 'off',                 // Handled by Node resolver
    'node/no-unpublished-import': 'off',
    'node/no-extraneous-dependencies': 'warn',
    'node/no-process-exit': 'warn',                  // Use proper exit strategies
    'node/handle-callback-err': 'error',             // Always handle errors in callbacks

    // Security (MongoDB / Express specific)
    'security/detect-object-injection': 'warn',      // Prevent injection via dynamic keys
    'security/detect-non-literal-regexp': 'warn',
    'security/detect-non-literal-require': 'warn',
    'security/detect-possible-timing-attacks': 'warn',
    'security/detect-eval-with-expression': 'error',

    // General JS
    'no-unused-vars': ['warn', { argsIgnorePattern: '^_' }],
    'no-console': 'off',             // console.log is fine in backend
    'no-debugger': 'error',
    'no-var': 'error',
    'prefer-const': 'warn',
    'eqeqeq': ['error', 'always'],
    'curly': ['warn', 'all'],
    'no-duplicate-imports': 'error',

    // Async / Promises
    'no-async-promise-executor': 'error',
    'no-await-in-loop': 'warn',      // Prefer Promise.all() over serial awaits
    'require-await': 'warn',         // Avoid async functions without await

    // MongoDB / Mongoose specific
    'no-shadow': 'warn',             // Prevent variable shadowing in model callbacks
  },
  ignorePatterns: [
    'node_modules/',
    'dist/',
  ],
};
