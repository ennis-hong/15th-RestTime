module.exports = {
  content: [
    "./app/views/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/assets/stylesheets/**/*.css",
    "./app/javascript/**/*.js",
  ],
  plugins: [require("daisyui")],
  daisyui: {
    themes: [
      {
        mytheme: {
          "primary": "#4a7c59",
          "secondary": "#a98467",
          "accent": "#abc178",
          "neutral": "#dde5b6",
          "base-100": "#f3f4f6",
          "info": "#f0ead2",
          "success": "#b5c99a",
          "warning": "#f4a259",
          "error": "#bc4b51",
        },
      },
    ],
  },
};