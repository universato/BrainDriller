import { createApp } from 'vue'
import App from './drill_form2.vue'

document.addEventListener('DOMContentLoaded', () => {
  const selector = '#js-drill-form';
  if(document.querySelector(selector)){
    createApp(App).mount(selector);
  }
})
