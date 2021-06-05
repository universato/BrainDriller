<template>
  <div id="app panel">
    <input type="text" v-model="title"><br>
    <textarea type="textarea" v-model="statement"></textarea><br>
    <div class="problem-statement" v-html="compiledMarkdown(statement)"></div>
    <ol class="problem-choices">
      <li
        v-for="(choice, choiceNo) in choices"
        :key="choiceNo"
        class="problem-choice"
        v-html="compiledMarkdown(choice)"
      >
      </li>
    </ol>
    <div class="btn">
      <button @click="saveProblem()" class="btn-std">問題を保存する</button>
    </div>
  </div>
</template>

<script>
import marked from 'marked';
import createMarkdown from 'safe-marked';
import DOMPurify from 'dompurify';
import hljs from 'highlight.js';

export default {
  data() {
    return {
      title: "",
      statement: "",
      choices: [],
    }
  },
  created() {
    marked.setOptions({
      langPrefix: 'hljs ',
      // sanitize: true,
      gfm: true,
      breaks: true,
      // highlightjsを使用したハイライト処理を追加
      highlight: function(code, lang) {
        return hljs.highlightAuto(code, [lang]).value
      }
    });
    // const markdown = createMarkdown({
    //   marked: {
    //     langPrefix: 'hljs ',
    //     // sanitize: true,
    //     gfm: true,
    //     breaks: true,
    //     // highlightjsを使用したハイライト処理を追加
    //     highlight: function(code, lang) {
    //       return hljs.highlightAuto(code, [lang]).value
    //     }
    //   }
    // })

    const pathnames = location.pathname.split('/'); // ["", "problems", "5"]
    const problem_id = pathnames[2];
    const url = new URL(location.href);

    fetch(`/api/problems/${problem_id}.json`, {
        method: 'GET',
        headers: { 'X-Requested-With': 'XMLHttpRequest', },
        credentials: 'same-origin',
        redirect: 'manual',
      }
    ).then(response => {
      return response.json()
    }).then(json => {
      this.problem = json.problem
      this.title = json.problem.title
      this.statement = json.problem.statement
      this.statement = json.problem.statement
      this.choices = json.problem.choices
    }).catch(error => {
      console.warn('Failed to parsing', error)
    })
  },
  methods: {
    compiledMarkdown(md) {
      return DOMPurify.sanitize(marked(md));
    },
    saveProblem() {
      console.log("method saveProblem");
      const body = {
        problems: this.problems,
        answer_paper: this.answerPaper
      }
      fetch(`/api/problems/id`, {
        method: 'POST',
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          "Content-Type": "application/json",
        },
        credentials: 'same-origin',
        redirect: 'manual',
        body: JSON.stringify(body),
      }).then(response => {
        return response;
      }).then(json => {
        // console.log(json)
        // console.log("posted Answer Paper")
      }).catch(error => {
        console.warn('Failed to parsing', error)
      })
    }
  }
}
</script>

<style scoped>
</style>
