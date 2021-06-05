import { createApp } from 'vue'
import App from './problem_edit.vue'

document.addEventListener('DOMContentLoaded', () => {
  const selector = '#js-problem-edit';
  if(document.querySelector(selector)){
    createApp(App).mount(selector);
  }
})
