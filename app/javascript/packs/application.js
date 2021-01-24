// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "stylesheets/application.scss"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

window.handleSortChange = (event) => {
  const target = event.target
  const sort = target.value

  if (['_score_desc', 'other'].includes(sort)) return

  const match = sort.match(/(.+)_(desc|asc)$/)
  const field = match[1]
  const direction = match[2]

  const location = `sort[field]=${field}&sort[direction]=${direction}`
  window.location.search = location
}
