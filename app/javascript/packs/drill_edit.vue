<template>
  <div id="app">
    ドリル作成者<div>{{ drillUserName }}</div>
    <div v-if="drillOnEdit">
      <form id="drill-form" class="drill-form">
        <button @click="saveDrillAndCloseEdit">保存して編集終了</button><br>
        ドリルのタイトル(必須): <input type="text" v-model="title" name="drill-title">
        <br>
        ドリルの説明: <textarea v-model="guide" class="statement" name="drill-guide"></textarea>
      </form>
    </div>
    <div v-else>
      <button @click="drillOnEdit = !drillOnEdit">編集画面へ</button>
      ドリルのタイトル(必須): <div>{{ title }} </div>
      <br>
      ドリルの説明: <div v-html="compiledMarkdown(guide)" > </div>
    </div>
    <div v-if="loaded">
      <br><br>
      <div v-if="problems.size == 0">
        登録されている問題が0です。
      </div>
      <div v-else>
        登録されている問題数は、{{ problems.length }} 問です。
      </div>
    </div>
    <div v-else>
      ドリルをロード中です。
    </div>
    <div>
      このドリルの状態は、{{ drillStateJP }} です。
    </div>
    <button @click="updateDrillAsDraft">下書きで保存する</button>
    <button @click="updateDrillAsOpen">公開で保存する</button>

    <div v-for="(problem, index) in problems" :key="index">
      <br><br>
      <button @click="isEdit[index] = !isEdit[index]">切り替え</button>
      <br>
      問題No. {{ index }}<br>
      <div v-if="isEdit[index]">
        問題の見出し<input v-model="problems[index].title">
        <br>問題文<br>
        <textarea v-model="problems[index].statement" class="statement"></textarea>
        <br>選択肢<br>
        <div v-for="(choice, choiceIndex) in problems[index].choices" :key="choiceIndex">
          <textarea v-model="problems[index].choices[choiceIndex]" class="statement"></textarea>
        </div>

        <button @click="problems[index].choices.push('')">選択肢の追加</button>
        <br><br>
        <button @click="deleteProblemAt(index)">問題No.{{ index }}の削除</button>
      </div>
      <div v-else>
        問題の見出し<div> {{ problems[index].title}} </div>
        問題文: <div v-html="compiledMarkdown(problems[index].statement)"></div>
        <div v-for="(choice, choiceIndex) in problems[index].choices" :key="choiceIndex">
          <div
            v-html="compiledMarkdown(problems[index].choices[choiceIndex])"
            class="statement"
          >
          </div>
        </div>
      </div>
    </div>

    <br><br>
    <button @click="addProblem">問題の入力欄を追加する</button>
    <br><br>
    <button @click="updateDrillAsDraft">下書きで保存する</button>
    <br>
    <button @click="updateDrillAsOpen">公開で保存する</button>
  </div>
</template>

<script>
import marked from 'marked';
import DOMPurify from 'dompurify';
import hljs from 'highlight.js';

export default {
  data() {
    return {
      drill: null,
      title: "",
      guide: "",
      drillState: null,
      drillOnEdit: false,
      drillUser: null,
      problems: [],
      isEdit: [],
      loaded: false,
      showModal: false,
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

    const pathnames = location.pathname.split('/'); // ["", "drills", "5"]
    const drill_id = pathnames[2];
    const url = new URL(location.href);

    fetch(`/api/drills/${drill_id}.json`, {
        method: 'GET',
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
        },
        credentials: 'same-origin',
        redirect: 'manual',
      }
    ).then(response => {
      return response.json()
    }).then(json => {
      this.drill =  json.drill
      this.drillId =  json.drill.id
      this.title = json.drill.title
      this.guide = json.drill.guide
      this.drillState = json.drill.state
      this.drillUser = json.drillUser
      this.problems = json.problems
      this.isEdit =  new Array(this.problems.length).fill(false);
      this.loaded = true;
    }).catch(error => {
      console.warn('Failed to parsing', error)
    })
  },
  methods: {
    compiledMarkdown(md) {
      return DOMPurify.sanitize(marked(md));
    },
    deleteProblemAt(problem_index) {
      let check = confirm('本当に削除しますか。OKなら削除です。');
      if(check){
        this.problems.splice(problem_index, 1);
        this.isEdit.splice(problem_index, 1);
      }
    },
    saveDrillAndCloseEdit() {
      this.saveDrill();
      this.drillOnEdit = false;
    },
    updateDrillAsDraft() {
      console.log("updateDrillAsDraft()")
      this.drillState = "draft";
      this.saveDrill();
    },
    updateDrillAsOpen() {
      console.log("updateDrillAsOpen()")
      this.drillState = "full_open";
      this.saveDrill();
    },
    addProblem() {
      this.problems.push({
        title: "",
        statement: "",
        choices: ["", "", "", ""],
        correctOption: 0,
      })
      this.isEdit.push(true);
    },
    saveDrill(){
      console.log("saveDrill")
      // console.log(this.token);
      const params = {
        drillTitle: this.title,
        drillGuide: this.guide,
        drillState: this.drillState,
        problems: this.problems,
      }
      fetch(`/drills/${this.drillId}`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': this.token()
        },
        credentials: 'same-origin',
        redirect: 'manual',
        body: JSON.stringify(params)
      })
        .then(response => {
          console.log(response)
          console.log(response.headers)
          console.log(response.status)
          console.log(response.statusText)
          console.log(response.type)
          console.log(response.url)
          console.log(response.body)
        })
        .then(json=> {
        })
        .catch(error => {
          console.warn('Failed to parsing', error)
        })
    },
    token() {
      const meta = document.querySelector('meta[name="csrf-token"]')
      return meta ? meta.getAttribute('content') : ''
    },
  },
  computed: {
    problem_link(id) {
      return "problems/" + id
    },
    drillStateJP() {
      if(this.drillState === "full_open") {
        return "公開"
      } else if(this.drillState === "draft") {
        return "下書き"
      } else {
        // console.log(this.drillState)
        // console.log("シークレット")
        return "シークレット"
      }
    },
    drillUserName() {
      if(this.drillUser) {
        return this.drillUser.login_name;
      } else {
        return "";
      }
    }
  }
}
</script>

<style scoped>
.statement {
  width: 80%;
}
</style>
