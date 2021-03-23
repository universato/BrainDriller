import { createApp } from 'vue'
import App from './solve.vue'

document.addEventListener('DOMContentLoaded', () => {
  const selector = '#js-solve';
  if(document.querySelector(selector)){
    createApp(App).mount(selector);
  }
})
