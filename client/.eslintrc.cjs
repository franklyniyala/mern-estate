module.exports = {
  root: true,
  env: {
    browser: true,
    es2022: true,
  },
  extends: [
    'eslint:recommended',
    'plugin:react/recommended',
    'plugin:react/jsx-runtime',       // React 17+ no need to import React
    'plugin:react-hooks/recommended',
    'plugin:jsx-a11y/recommended',    // Accessibility linting
  ],
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
    ecmaFeatures: {
      jsx: true,
    },
  },
  plugins: ['react', 'react-hooks', 'jsx-a11y'],
  settings: {
    react: {
      version: 'detect', // Auto-detect React version
    },
  },
  rules: {
    // React
    'react/prop-types': 'warn',
    'react/display-name': 'warn',
    'react/no-unknown-property': 'error',
    'react/jsx-no-duplicate-props': 'error',
    'react/jsx-no-undef': 'error',
    'react/jsx-uses-react': 'off',     // Not needed with React 17+
    'react/react-in-jsx-scope': 'off', // Not needed with React 17+
    'react/self-closing-comp': 'warn',
    'react/no-array-index-key': 'warn',
    'react/no-danger': 'warn',

    // Hooks
    'react-hooks/rules-of-hooks': 'error',
    'react-hooks/exhaustive-deps': 'warn',

    // General JS
    'no-unused-vars': ['warn', { argsIgnorePattern: '^_' }],
    'no-console': ['warn', { allow: ['warn', 'error'] }],
    'no-debugger': 'error',
    'no-duplicate-imports': 'error',
    'prefer-const': 'warn',
    'no-var': 'error',
    'eqeqeq': ['error', 'always'],
    'curly': ['warn', 'all'],
    'no-undef': 'error',

    // Accessibility (jsx-a11y)
    'jsx-a11y/alt-text': 'warn',
    'jsx-a11y/anchor-is-valid': 'warn',
  },
  ignorePatterns: [
    'node_modules/',
    'dist/',
    'build/',
    'vite.config.js',
    'postcss.config.js',
    'tailwind.config.js',
  ],
};
