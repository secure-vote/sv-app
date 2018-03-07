'use strict';

const loadElm = function() {

    const Elm = require('./src/SecureVote/SPAs/Swarm/Main.elm');

    if (typeof Elm !== "undefined") {

        window['Elm'] = Elm;

        var node = document.getElementById('sv-fullscreen');
        var flags = {
            votingPrivKey: '', //Uint8Array.from(Array(32).fill(0)),
            democracyId: 31,
            admin: true,
            singleDemocName: "SV Demo"
        };

        const app = Elm.SecureVote.SPAs.Swarm.Main.embed(node, flags);

        initialisePorts(app);

        // Remove Loading Spinner
        var spinner = document.getElementById("loading-screen");
        spinner.parentNode.removeChild(spinner);

    } else {
        setTimeout(loadElm, 100);
    }
}

loadElm();