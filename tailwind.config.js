module.exports = {
  content: ["./{app,src}/**/*.elm"],
  theme: {
    extend: {},
    fontFamily: {
      display: ["Ubuntu"],
      body: ["Lato"],
    },
    colors: {
      dark: "#001C22",
      light: "#EBEEEF",
      highlight: "#0066D9",
      white: "#F8F8F8",
      black: "#000000",
      gray: "#A6A6A6",
      blue: "#1e4d3d",
    },
  },
  variants: {},
  plugins: [require("@tailwindcss/ui")],
};
