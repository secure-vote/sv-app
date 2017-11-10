var path = require("path");
const CopyWebpackPlugin = require('copy-webpack-plugin');
const HTMLWebpackPlugin = require('html-webpack-plugin');

const _dist = '_dist';
const outputPath = path.join(__dirname, _dist);
const CopyWebpackPluginConfig = new CopyWebpackPlugin([
  {from: './web/css', to: outputPath + '/css'},
  {from: './web/js', to: outputPath + '/js'},
  {from: './web/img', to: outputPath + '/img'}
]);

module.exports = {
  entry: {
    app: [
      './web/index.js'
    ]
  },

  output: {
    path: path.resolve(__dirname + '/_dist'),
    filename: '[name].js',
  },

  module: {
    rules: [
      {
        test: /\.css$/,
        exclude: [
            /elm-stuff/, /node_modules/
        ],
        loaders: ["css-loader"]
      },
      {
        test:    /\.html$/,
        exclude: /node_modules/,
        loader:  'file-loader?name=[name].[ext]',
      },
      {
        test:    /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader:  'elm-webpack-loader?verbose=true&warn=true',
      },
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'url-loader?limit=10000&mimetype=application/font-woff',
      },
      {
        test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'file-loader',
      },
    ],

    noParse: /\.elm$/,
  },
  plugins: [
      CopyWebpackPluginConfig,
      new HTMLWebpackPlugin({
          // using .ejs prevents other loaders causing errors
          template: 'web/index.ejs',
          // inject details of output file at end of body
          inject: 'body'
      })
  ],

  devServer: {
    inline: true,
    stats: { colors: true },
  },


};
