
// This file is not being used yet

const initialisePorts = (app) => {

    app.ports.writeLocalStorageImpl(({key, value}) => {
        localStorage.setItem(key, JSON.stringify(value))
    })
}