<template>
  <div id="app panel">
    <div class="btn">
      <button @click="saveProblem()" class="btn-std">問題を保存する</button>
      <div v-if="isEdit">
        <button @click="toShowMode()" class="btn-std">閲覧画面に切り替え</button>
      </div>
      <div v-else>
        <button @click="toEditMode()" class="btn-std">編集画面に切り替え</button>
      </div>
    </div>

    <br>問題番号:
    <div>{{ problem_id }}</div>

    <div v-if="isEdit">
      <input type="text" v-model="title"><br>
    </div>
    <div v-else>
      <div>ドリル名: {{ title }}</div><br>
    </div>
    <div v-if="isEdit">
      <textarea type="textarea" class="statement" v-model="statement"></textarea><br>
    </div>
    <div class="problem-statement" v-html="compiledMarkdown(statement)"></div>

    選択肢
    <ol class="problem-choices">
      <li
        v-for="(choice, choiceNo) in choices"
        :key="choiceNo"
        class="problem-choice"
        v-html="compiledMarkdown(choice)"
      >
      </li>
    </ol>

    選択肢
    <div v-if="isEdit">
      <ol class="problem-choices">
        <li
          v-for="(choice, choiceNo) in choices"
          :key="choiceNo"
          class="problem-choice"
          type="text"
        >
        </li>
      </ol>
    </div>

    正解
    <div v-if="isEdit">
      <input type="number" v-model.number="correct_option">
    </div>
    <div v-else>
      <div class="correct_option">{{ correct_option }}</div>
    </div>

    <div v-if="isEdit">
      <textarea type="textarea" class="explanation" v-model="explanation"></textarea><br>
    </div>
    <div class="explanation">{{ explanation }}</div>

    <div class="btn">
      <button @click="saveProblem()" class="btn-std">問題を保存する</button>
      <div v-if="isEdit">
        <button @click="toShowMode()" class="btn-std">閲覧画面に切り替え</button>
      </div>
      <div v-else>
        <button @click="toEditMode()" class="btn-std">編集画面に切り替え</button>
      </div>
    </div>

    <a :href="drill_url()">ドリルの問題一覧</a>
  </div>
</template>

<script>
import marked from 'marked';
import DOMPurify from 'dompurify';
import hljs from 'highlight.js';

export default {
  data() {
    return {
      drill_id: null,
      problem_id: null,
      title: "",
      statement: "",
      explanation: "",
      choices: [],
      correct_option: null,
      isEdit: false,
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

    const pathnames = location.pathname.split('/'); // ["", "problems", "5"]
    const problem_id = pathnames[2];
    this.problem_id = problem_id;
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
      let problem = json.problem
      this.problem = problem
      this.drill_id = problem.drill_id
      this.problem_id = problem.id
      this.title = problem.title
      this.statement = problem.statement
      this.choices = problem.choices
      this.correct_option = problem.correct_option
      this.explanation = problem.explanation
    }).catch(error => {
      console.warn('Failed to parsing', error)
    })
  },
  methods: {
    compiledMarkdown(md) {
      return DOMPurify.sanitize(marked(md));
    },
    token() {
      const meta = document.querySelector('meta[name="csrf-token"]')
      return meta ? meta.getAttribute('content') : ''
    },
    saveProblem() {
      console.log("method saveProblem");
      const body = {
        problem_id: this.problem_id,
        title: this.title,
        statement: this.statement,
        choices: this.choices,
        correct_option: this.correct_option,
        explanation: this.explanation
      }
      fetch(`/api/problems/${this.problem_id}`, {
        method: 'PATCH',
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          "Content-Type": "application/json",
          "X-CSRF-Token": this.token(),
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
    },
    toEditMode() {
      this.isEdit = true
    },
    toShowMode() {
      this.isEdit = false
    },
    drill_url() {
      return `/drills/${this.drill_id}/problems`
    },
  },
  conputed: {

  }
}
</script>

<style scoped>
.statement {
  width: 80%;
}

.explanation {
  width: 80%;
}
</style>
