'use strict';

setTimeout(() => {
    const Elm = require('./src/Main.elm');
    const app = Elm.Main.embed(document.getElementById('sv-fullscreen'));

}, 400);


