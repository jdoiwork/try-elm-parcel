import { Elm } from './Main.elm'

const app = Elm.Main.init({
  node: document.querySelector('main')
})

//app.ports.timerRefreshed.send("abc")
console.log(app)
console.log(app.ports)
app.ports.refreshTimer.send("hello")