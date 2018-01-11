'use strict';

setTimeout(() => {
    const Elm = require('./src/MainDemo.elm');
const app = Elm.Main.embed(document.getElementById('sv-fullscreen'));

// Remove Loading Spinner
var element = document.getElementById("loading-screen");
element.parentNode.removeChild(element);

}, 400);


