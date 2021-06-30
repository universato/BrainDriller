import { createApp } from 'vue'
import App from './drill_edit.vue'

document.addEventListener('DOMContentLoaded', () => {
  const selector = '#js-drill-edit';
  if(document.querySelector(selector)){
    createApp(App).mount(selector);
  }
})
