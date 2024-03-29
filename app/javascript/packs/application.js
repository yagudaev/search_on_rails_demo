// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "form-request-submit-polyfill"
import "stylesheets/application.scss"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

window.handleSortChange = (event) => {
  const target = event.target
  const sort = target.value

  if (["other"].includes(sort)) return

  const match = sort.match(/(.+)_(desc|asc)$/)
  const field = match[1]
  const direction = match[2]
  const params = new URLSearchParams(window.location.search)
  params.set('sort[field]', field)
  params.set('sort[direction]', direction)

  const location = `${window.location.pathname}?${params.toString()}`
  Turbolinks.visit(location)
}

window.handleFormSubmit = (target) => {
  target.form.requestSubmit()
}

function makeGetFormsSubmitWithTurbolinks() {
  // Source: https://github.com/turbolinks/turbolinks/issues/272#issuecomment-615038967
  document.addEventListener("turbolinks:load", function (event) {
    for (let form of document.querySelectorAll("form[method=get]:not([data-remote=true])")) {
      form.addEventListener("submit", function (event) {
        event.preventDefault()
        const entries = [...new FormData(event.target).entries()]
        const actionUrl = new URL(event.target.action)
        const currentUrl = new URL(location.href)
        // if pathname not changed, hand over per parameter to next page.
        if (actionUrl.pathname === currentUrl.pathname && currentUrl.searchParams.has("per")) {
          actionUrl.searchParams.set("per", currentUrl.searchParams.get("per"))
        }
        entries.forEach((entry) => actionUrl.searchParams.append(...entry))
        Turbolinks.visit(actionUrl.toString())
      })
    }
  })
}

makeGetFormsSubmitWithTurbolinks()
