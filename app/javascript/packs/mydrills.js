import { createApp } from 'vue'
import App from './mydrills.vue'

document.addEventListener('DOMContentLoaded', () => {
  const selector = '#js-mydrills';
  if(document.querySelector(selector)){
    createApp(App).mount(selector);
  }
})
