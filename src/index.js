import { Elm } from './Main.elm'

import dayjs from 'dayjs'
import bulma from 'bulma'

const app = Elm.Main.init({
  node: document.querySelector('main')
})

//app.ports.timerRefreshed.send("abc")
console.log(app)
console.log(app.ports)

function refreshTimer() {
  app.ports.refreshTimer.send(dayjs(Date.now()).format('YYYY-MM-DD HH:mm:ss'))
  window.setTimeout(refreshTimer, 1000 + Math.random() * 4000)
}

window.setTimeout(refreshTimer, 1000)

