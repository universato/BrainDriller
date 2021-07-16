<template>
  <div id="app" class="container">
    <div class="row">
      <div class="col-md-6 col-xs-12 ml-0">
        <label for="drill-title" class="col-12">ドリルのタイトル(必須):</label>
        <input type="text" v-model="title" id="drill-title" class="form-control form-control-lg fs-3">
        <div :class="{ 'text-danger': title.length === 0 }"> 文字数:<span>{{ title.length }}</span> </div>
      </div>
    </div>
    <div class="row mt-4">
      <div class="col-md-6 col-xs-12 ml-0">
        <label for="drill-guide">ドリルの説明:</label>
        <textarea v-model="guide" class="form-control fs-4" id="drill-guide" style="height: 12rem"></textarea>
      </div>

      <div class="col-md-6 col-xs-12">
        <div>プレビュー</div>
        <div v-html="compiledMarkdown(guide)" class="markdown-form__preview fs-4"> </div>
      </div>
    </div>
    <button @click="saveDrill" class="btn btn-primary fs-4 w-75 my-3 text-center" :disabled="title.length === 0">
      ドリルを非公開で仮保存
    </button>
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
      drillOnEdit: true,
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
      fetch(`/drills`, {
        method: 'POST',
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
          return response.json();
        })
        .then(json=> {
          console.log(json);
          location.href = json.redirect_edit_url;
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
</style>
