const cssnano = require("cssnano");

const purgecss = require("@fullhuman/postcss-purgecss")({
  content: ["./{app,src}/**/*.elm"],
  defaultExtractor: (content) => content.match(/[\w-/:]+(?<!:)/g) || [],
});

module.exports = {
  plugins: [
    require("tailwindcss"),
    require("autoprefixer"),
    process.env.NODE_ENV === "production"
      ? cssnano({ preset: "default" })
      : null,
    ...(process.env.NODE_ENV === "production" ? [purgecss] : []),
  ],
};
