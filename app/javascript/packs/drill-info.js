import { createApp } from 'vue'
import App from './drill-info.vue'

document.addEventListener('DOMContentLoaded', () => {
  const selector = '#js-drill-info';
  if(document.querySelector(selector)){
    createApp(App).mount(selector);
  }
})
