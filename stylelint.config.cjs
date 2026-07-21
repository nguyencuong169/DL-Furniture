module.exports = {
  extends: [],
  rules: {
    // focus on catching actual syntax issues / typos
    'font-family-no-missing-generic-family-keyword': null,
    'property-no-unknown': null,
    // removed: rule name differs by stylelint version
    'no-unknown-custom-properties': true,
    'color-no-invalid-hex': true,
    // property-no-unknown removed duplicate
  },
};

