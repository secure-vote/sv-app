'use strict';

setTimeout(() => {
    const Elm = require('./src/MainDemo.elm');
    var node = document.getElementById('sv-fullscreen');
    var flags = {
        votingPrivKey: "test",
        democracyId: 31,
        admin: false
    };
    const app = Elm.MainDemo.embed(node,flags);

    // Remove Loading Spinner
    var element = document.getElementById("loading-screen");
    element.parentNode.removeChild(element);

}, 400);


