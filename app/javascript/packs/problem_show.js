import { createApp } from 'vue'
import App from './problem_show.vue'

document.addEventListener('DOMContentLoaded', () => {
  const selector = '#js-problem-show';
  if(document.querySelector(selector)){
    createApp(App).mount(selector);
  }
})
