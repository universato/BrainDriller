<template>
  <div id="app panel">
    <div v-if="drill" class="solve-drill">
      <div class="drill-id"> ドリルID：{{ drill.id }} </div>
      <div class="solve-drill-title"> ドリルのタイトル： {{ drill.title }} </div>
    </div>
    <div v-if="state=='solving'">
      <div class="problem">
        <div v-if="currentProblem">
          <div class="problem-id"> 問題ID{{ currentProblem.id }} </div>
          <div class="problem-id"> {{ currentProblemIndex +1 }}問目 </div>
          <div class="problem-title"> {{ currentProblem.title }} </div>
          <div class="problem-statement" v-html="compiledMarkdown(currentProblem.statement)"></div>
          <ol class="problem-choices">
            <li
              v-for="(choice, idx) in currentProblem.choices"
              :key="idx"
              class="problem-choice"
              @click="selectOption(idx)"
            >
              {{ choice }}
            </li>
          </ol>
        </div>
        <div v-if="false && 0 < currentProblemIndex"><button @click="prevProblem()" class="btn-prev btn-std">前のクイズへ</button></div>
        <div v-if="currentProblemIndex < problems.length - 1"><button @click="nextProblem()" class="btn-next btn-std">わからない</button></div>
        <div v-if="currentProblemIndex < problems.length - 1"><button @click="notSure()" class="btn-next btn-std">次のクイズへ</button></div>
        <div v-if="currentProblemIndex < problems.length - 1"><button @click="grade()" class="btn-std">中断して採点する</button></div>
        <div v-if="currentProblemIndex == problems.length - 1"><button @click="grade()" class="btn-std">採点する</button></div>
      </div>
    </div>
    <div v-else-if="state=='result'">
      <div>{{ correct_count }}</div>
      <ol>
        <li v-for="(problem, idx) in problems" :key="problem.id">
          <div class="problem-id"> 問題ID{{ problem.id }} </div>
          <div class="problem-title"> {{ problem.title }} </div>
          <div class="problem-statement" v-html="compiledMarkdown(problem.statement)"> </div>
          <div class="problem-selected_option"> {{ answerPaper[idx] }} </div>
          <div class="problem-correct_option"> {{ problem.correct_option }} </div>
          <div class="problem-explanation" v-html="compiledMarkdown(problem.explanation)"> </div>
        </li>
      </ol>

    </div>
  </div>
</template>

<script>
import marked from 'marked';
import hljs from 'highlight.js';
//import vuePlugin from "@highlightjs/vue-plugin";
// Vue.use(vuePlugin());
// import hljs from 'highlightjs';

export default {
  data() {
    return {
      currentProblemIndex: 0,
      message: "問題を解いています！",
      drill: null,
      problems: [],
      state: "solving",
      currentProblem: null,
      answerPaper: {},
      correct_count: 0,
    }
  },
  created() {
    marked.setOptions({
      // code要素にdefaultで付くlangage-を削除
      langPrefix: '',
      // highlightjsを使用したハイライト処理を追加
      highlight: function(code, lang) {
        return hljs.highlightAuto(code, [lang]).value
      }
    });

    const pathnames = location.pathname.split('/'); // ["", "solve", "5"]
    const drill_id = pathnames[2];
    const url = new URL(location.href);
    // const isRand = url.searchParams.get('rand');
    // const is = url.searchParams.get('');
    fetch(`/api/drills/${drill_id}.json${url.search}`, {
        method: 'GET',
        headers: { 'X-Requested-With': 'XMLHttpRequest', },
        credentials: 'same-origin',
        redirect: 'manual',
      }
    ).then(response => {
      return response.json()
    }).then(json => {
      this.drill = json.drill
      this.problems = []
      json.problems.forEach(r => { this.problems.push(r) })
      this.currentProblem = this.problems[0];
    }).catch(error => {
      console.warn('Failed to parsing', error)
    })
  },
  methods: {
    selectOption(choiceNo) {
      console.log(`selectOption Method ${choiceNo}`);
      console.log(this.answerPaper);
      this.answerPaper[this.currentProblem.id] = choiceNo;
      if(0 <=  this.currentProblemIndex && this.currentProblemIndex < this.problems.length - 1) {
        this.currentProblemIndex += 1;
        this.currentProblem = this.problems[this.currentProblemIndex];
      } else if (this.currentProblemIndex == this.problems.length - 1) {
        console.log("最後の問題です");
      } else if (this.currentProblemIndex < 0 || this.problems.length - 1 < this.currentProblemIndex) {
        console.log("問題番号が0未満になっているか、超越してます");
      }
    },
    grade() {
      console.log("method grade");
      this.postAnswerPaper();
      this.correct_count = 0
      for(let i = 0; i < this.problems.length; i++){
        let problem = this.problems[i];
        console.log([problem.id])
        if(this.answerPaper[problem.id] + 1 == problem.correct_option){
          this.correct_count += 1
        }
      }
      this.state = "result"
    },
    postAnswerPaper() {
      console.log("will post Answer Paper")
      const body = {
        problems: this.problems,
        answer_paper: this.answerPaper
      }
      fetch(`/api/drills/grade`, {
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
        console.log(json)
        console.log("posted Answer Paper")
      }).catch(error => {
        console.warn('Failed to parsing', error)
      })
    },
    notSure() {
      nextProblem();
    },
    nextProblem() {
      if(this.problems.length - 1 <= this.currentProblemIndex) { return }
      this.currentProblemIndex += 1;
      this.currentProblem = this.problems[this.currentProblemIndex];
    },
    prevProblem() {
      if(this.currentProblemIndex <= 0) { return }
      this.currentProblemIndex -= 1;
      this.currentProblem = this.problems[this.currentProblemIndex];
    },
    compiledMarkdown(md) {
      return marked(md);
    }
  }
}
</script>

<style scoped>

.solve-drill {
  /* border: solid 1px #eee; */
  margin: 8px;
  padding: 8px;
  border: none 0 #fff;
  border-radius: 4px;
  background-color: #fff;
}

.solve-drill-title {
  /* width: 800px; */
  /* border: solid 1px #eee; */
  background-color: #fff;
}

.panel {
  background-color: #fafafa;
}

.problem {
  margin: 8px;
  padding: 8px;
  border: none 0 #fff;
  border-radius: 4px;
  background-color: #fff;
}

.problem-title {
  /* width: 800px; */
  /* border: solid 1px #eee; */
  background-color: #fff;
}

.problem-statement {
  /* width: 800px; */
  /* border: solid 1px #eee; */
  padding: 16px;
  background-color: #fff;
}

.problem-choice {
  /* width: 800px; */
  /* border: solid 1px #eee; */
  border-radius: 4px;
  background-color: #e1e1e1;
  cursor: pointer;
  margin: 8px;
  padding: 8px;
}

.problem-choice:hover {
  background-color: #efefef;
}

.problem-explanation {
  /* width: 800px; */
  /* border: solid 1px #eee; */
  background-color: #fff;
}

p {
  font-size: 2em;
  text-align: center;
}
</style>
