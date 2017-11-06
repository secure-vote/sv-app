'use strict';

require('./css/vendor/tachyons.min.css');
require('./css/vendor/material.blue_grey-deep_orange.min.css');
require('./css/securevote.css');
require('./index.html');

const Elm = require('./src/Main.elm');
const app = Elm.Main.embed(document.getElementById('sv-fullscreen'));