module.exports = {
  build: {
    "index.html": "index.html",
    "app.js": [
      "javascripts/app.js"
    ],
    "app.css": [
      "stylesheets/app.css"
    ],
    "images/": "images/"
  },
  networks: {
      "ropsten": {
          host: "parity-ropsten",
          port: 8545
      }
  },
  rpc: {
    host: "testrpc",
    port: 8545
  }
};
