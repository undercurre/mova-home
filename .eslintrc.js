module.exports = {
    root: true,
    env: {
        browser: true,
        es6: true,
        node: true,
    },
    extends: [
        'eslint:recommended',
        'plugin:react/recommended',
        'plugin:import/recommended',
    ],
    settings: {
        'import/resolver': {
            node: {
                extensions: [
                    '.js',
                    '.android.js',
                    '.ios.js',
                ],
            },
        },
        react: {
            version: 'latest',
        },
    },
    parser: 'babel-eslint',
    parserOptions: {
        ecmaFeatures: {
            jsx: true,
        },
        ecmaVersion: 10,
        sourceType: 'module',
    },
    plugins: [
        'react',
    ],
    rules: {
        'no-unused-vars': ['error', { 'argsIgnorePattern': '^_' }],
        'react/jsx-filename-extension': [1, { extensions: ['.js', '.jsx'] }],
        'quotes': [1, 'single'],
        'react/no-deprecated': 1,
        'react-native/sort-styles': 0,
        'react/no-direct-mutation-state': 0,
        'react/prop-types': [2, { 'ignore': ['navigation'] }],
        'no-dupe-keys': 1,
        'no-new-object': 1, //禁止使用new Object()
        'no-new-wrappers': 1, //禁止使用new创建包装实例，new String new Boolean new Number
        'no-constant-condition': 1,
        'no-control-regex': 0,
        'no-redeclare': 1,
        'indent': ['error', 4, { 'SwitchCase': 1 }],
        'import/default': 1,
        'no-console': 0,
    },
};
