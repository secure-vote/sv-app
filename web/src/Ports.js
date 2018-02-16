const initialisePorts = (app) => {

    // app.ports.writeLocalStorageImpl(({key, value}) => {
    //     localStorage.setItem(key, JSON.stringify(value))
    // })

    app.ports.sendBcData.subscribe(errWrapper("sendBcData")(sendDataToBlockchain));
    app.ports.getBcData.subscribe(errWrapper("getBcData")(getDataFromBlockchain));
    app.ports.writeLsImpl.subscribe(errWrapper("writeLsImpl")(writeToLocalStorage));
    app.ports.readLsImpl.subscribe(errWrapper("readLsImpl")(readFromLocalStorage));



    function sendDataToBlockchain(arg) {

        var [ref, data] = arg;

        // Talk to Blockchain
        setTimeout(function(){

            // Generate Receipt
            var txId = generateReceipt(data);

            // Send Receipt
            app.ports.receiptBcData.send([ref, txId]);

            // Wait for Blockchain Confirmation
            setTimeout(function(){

                // Send Blockchain Confirmation
                app.ports.confirmBcData.send(ref);
            }, 5000);

        }, 3000);

    }

    function getDataFromBlockchain(txId) {

        // Talk to Blockchain
        setTimeout(function(){

            // Get Data
            var data = "DATAAAAAA";

            // Send Receipt
            app.ports.receiveBcData.send(data);

        }, 3000);

    }

    function generateReceipt(data) {
        var receipt = Math.floor(Math.random() * 1000000).toString()
        return receipt;
    }

    function writeToLocalStorage({key, value}) {
        localStorage.setItem("sv_" + key, JSON.stringify(value))
    }

    function readFromLocalStorage(key) {
        var ls = localStorage.getItem("sv_" + key)
        app.ports.gotLsImpl.send({key: key, value: JSON.parse(ls)});
    }

    function errWrapper(fName) {
        return function(f) {
            return function(...args){
                try {
                    return f.apply(this, args);
                } catch (err) {
                    // error handling here
                    console.error("Function", fName, "produced error:", err);
                }
            }
        }
    }
}