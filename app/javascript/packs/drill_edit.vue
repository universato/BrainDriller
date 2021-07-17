<template>
  <div id="app">
    ドリル作成者<div>{{ drillUserName }}</div>
    <form v-if="drillOnEdit" id="drill-form">
      <button @click="saveDrillAndCloseEdit" class="btn btn-secondary fs-4">保存して編集終了</button><br>
      <div class="row">
        <div class="col-md-6 col-xs-12">
          <label for="drill-title" class="col-12 mt-2">ドリルのタイトル(必須):</label>
          <input type="text" v-model.trim="title" id="drill-title" class="form-control form-control-lg fs-3">
        </div>
      </div>
      <div class="row mt-4">
        <div class="col-md-6 col-xs-12 me-0">
          <label for="drill-guide">ドリルの説明:</label>
          <textarea v-model="guide" class="form-control fs-4" id="drill-guide" style="height: 12rem"></textarea>
        </div>
        <div class="col-md-6 col-xs-12">
          <div>プレビュー</div>
          <div v-html="compiledMarkdown(guide)" class="markdown-form__preview fs-4"> </div>
        </div>
      </div>
    </form>
    <div v-else>
      <button @click="drillOnEdit = !drillOnEdit" class="btn btn-secondary fs-4 mt-2">編集画面へ</button><br>
      ドリルのタイトル(必須):
      <div class="fs-1">{{ title }} </div> <br>
      ドリルの説明:
      <div v-html="compiledMarkdown(guide)" class="fs-4"> </div>
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
    <button @click="updateDrillAsDraft" class="btn btn-primary fs-4">下書きで保存する</button>
    <button @click="updateDrillAsOpen" class="btn btn-primary fs-4 mx-3">公開で保存する</button>

    <div v-for="(problem, index) in problems" :key="index">
      <br><br>
      <button @click="isEdit[index] = !isEdit[index]" class="btn btn-secondary fs-4">切り替え</button>
      <br>
      問題No. {{ index + 1 }}<br>
      <div v-if="isEdit[index]">
        <form class="problem-form">
          <label for="problem-title">問題の見出し</label>
          <input v-model="problems[index].title" class="form-control fs-4" name="problem-title" id="problem-title">
          <label for="problem-statement">問題文</label>
          <textarea v-model="problems[index].statement" id="problem-statement" class="form-control fs-4"></textarea>
          <br>選択肢<br>

          <div v-for="(choice, choiceIndex) in problems[index].choices" :key="choiceIndex">
            <textarea v-model="problems[index].choices[choiceIndex]" class="form-control fs-4"></textarea>
          </div>

          <button @click="problems[index].choices.push('')" class="btn btn-secondary fs-4">+選択肢の追加</button>
          <br><br>
          <button @click="deleteProblemAt(index)" class="btn btn-danger fs-4">問題No.{{ index + 1 }}の削除</button>
        </form>
      </div>
      <div v-else>
        <div class="fs-3 my-2"> {{ problems[index].title}} </div>
        <div v-html="compiledMarkdown(problems[index].statement)" class="fs-3 mb-2"></div>
        <div class="problem-choices">
          <div v-for="(choice, choiceIndex) in problems[index].choices" :key="choiceIndex" class="problem-choice fs-3">
            <div
              v-html="compiledMarkdown(problems[index].choices[choiceIndex])"
            >
            </div>
          </div>
        </div>
      </div>
    </div>

    <br><br>
    <button @click="addProblem" class="btn btn-primary fs-4">問題の入力欄を追加する</button>
    <br><br>
    <div v-if="problems.length > 0">
      <button @click="updateDrillAsDraft" class="btn btn-primary fs-4">下書きで保存する</button>
      <button @click="updateDrillAsOpen" class="btn btn-primary fs-4 mx-3">公開で保存する</button>
    </div>
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
          // console.log(response)
          // console.log(response.headers)
          // console.log(response.status)
          // console.log(response.statusText)
          // console.log(response.type)
          // console.log(response.url)
          // console.log(response.body)
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

.problem-choices {
  /* border-top: 1px solid #ccc; */
  margin-top: 8px;
  margin-left: 0;
}

.problem-choice {
  /* border: solid 1px #eee; */
  /* border-radius: 4px; */
  background-color: #e1e1e1;
  cursor: pointer;
  margin-top: 8px;
  padding: 8px;
}
</style>
