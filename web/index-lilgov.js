'use strict';

const loadElm = function() {

    const Elm = require('./src/SecureVote/SPAs/LilGov/Main.elm');

    if (typeof Elm !== "undefined") {

        window['Elm'] = Elm;

        var node = document.getElementById('sv-fullscreen');
        var flags = {};

        const app = Elm.SecureVote.SPAs.LilGov.Main.embed(node, flags);

        initialisePorts(app);

        // Remove Loading Spinner
        var spinner = document.getElementById("loading-screen");
        spinner.parentNode.removeChild(spinner);

    } else {
        setTimeout(loadElm, 100);
    }
}

loadElm();