const webpack = require('webpack');
const path = require("path");
const merge = require('webpack-merge');
const CleanWebpackPlugin = require('clean-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const HTMLWebpackPlugin = require('html-webpack-plugin');
const UglifyJSPlugin = require('uglifyjs-webpack-plugin');

var __DEV__ = false;
var TARGET_ENV = function () {
    console.log('Generating TARGET_ENV');
    switch (process.env.npm_lifecycle_event) {
        case 'build-web':
            return 'production';
        case 'web':
            __DEV__ = true;
            return 'development';
        case 'demo':
            __DEV__ = true;
            return 'demo';
        case 'build-demo':
            return 'demo';
        default:
            __DEV__ = true;
            return 'development'
    }
}();
var filename = (TARGET_ENV === 'production') ? '[name]-[hash].js' : '[name].js';

const _dist = '_dist';
const outputPath = path.join(__dirname, _dist);
const CopyWebpackPluginConfig = new CopyWebpackPlugin([
  {from: './web/css', to: outputPath + '/css'},
  {from: './web/js', to: outputPath + '/js'},
  {from: './web/img', to: outputPath + '/img'},
  {from: './web/_headers', to: outputPath}
]);


const genOutput = () => {
    let extra_dir = '';
    if (TARGET_ENV == 'demo' && !__DEV__) {
        extra_dir = '/demo';
    }
    return {
        output: {
            path: path.resolve(__dirname + '/_dist' + extra_dir),
            filename,  // set above dependent on whether it's production or not
        }
    };
}


const genElmLoader = () => {
    let extra = '';

    if (TARGET_ENV !== 'production') {
        extra += "&debug=true"
    }

    return {
        test:    /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader:  'elm-webpack-loader?verbose=true&warn=true' + extra,
    }
}


const genPlugins = () => {
    const extras = [];

    if (TARGET_ENV === 'demo') {
        extras.push(new HTMLWebpackPlugin({
            template: 'web/index-demo.ejs',
            inject: 'body',
        }))
    } else {
        extras.push(new HTMLWebpackPlugin({
                // using .ejs prevents other loaders causing errors
                template: 'web/index.ejs',
                // inject details of output file at end of body
                inject: 'body'
            }))
    }

    if (__DEV__) {
        extras.push(new webpack.NamedModulesPlugin())
        extras.push(new webpack.HotModuleReplacementPlugin())
    }

    return [
        CopyWebpackPluginConfig,
        ...extras
    ];
}


const common = {
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
      genElmLoader(),
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
  plugins: genPlugins(),

  devServer: {
    inline: true,
    stats: { colors: true },
  },
};



const genExports = (customConf) => {
    return merge(common, genOutput(), customConf);
}



if (TARGET_ENV === 'development') {
    console.log('Building for dev...');
    module.exports = genExports({
        entry: {
            app: [
                './web/index.js'
            ]
        },
        plugins: [
            // Prevents compilation errors causing the hot loader to lose state
            new webpack.NoEmitOnErrorsPlugin()
        ]
    });
}


if (TARGET_ENV === 'production') {
    console.log('Building for production...');
    module.exports = genExports({
        entry: {
            app: [
                './web/index.js'
            ]
        },
        plugins: [
            // Delete everything from output directory and report to user
            // NOTE: disabled for the moment - deploys through netlify are always clean anyway.
            // The reason it's disabled is that we can clean manually with `rm -r _dist`
            // new CleanWebpackPlugin([_dist], {
            //     root: __dirname,
            //     exclude: [],
            //     verbose: true,
            //     dry: false
            // }),
            CopyWebpackPluginConfig,
            new UglifyJSPlugin()
        ]
    });
}


if (TARGET_ENV === 'demo') {
    console.log('Building for demo...');
    module.exports = genExports({
        entry: {
            demo: [
                './web/index-demo.js'
            ]
        }
    });
}
