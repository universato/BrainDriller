import { createApp } from 'vue'
import App from './drill_form.vue'

document.addEventListener('DOMContentLoaded', () => {
  const selector = '#js-drill-form';
  if(document.querySelector(selector)){
    createApp(App).mount(selector);
  }
})
