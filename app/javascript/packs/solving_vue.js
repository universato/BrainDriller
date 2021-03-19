/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'hello_vue' %> (and
// <%= stylesheet_pack_tag 'hello_vue' %> if you have styles in your component)
// to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.

import { createApp } from 'vue'
import App from './solving.vue'

document.addEventListener('DOMContentLoaded', () => {
  const selector = '#js-solving';
  if(document.querySelector(selector)){
    createApp(App).mount(selector);
  }
})
