// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
// import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import 'bootstrap'
import '@fortawesome/fontawesome-free/js/all'
import '../stylesheets/application.scss'
import '../stylesheets/reset.scss'
import '../stylesheets/common.scss'
import '../stylesheets/button.scss'
import '../stylesheets/drill.scss'
import '../stylesheets/problems.scss'
import '../stylesheets/user.scss'
import '../stylesheets/highlightjs/hybrid.css'
import '../stylesheets/highlightjs/custom.scss'

Rails.start()
// Turbolinks.start()
ActiveStorage.start()

require('./hello_vue.js')
require('./solve_vue.js')
require('./drill_form_vue.js')
