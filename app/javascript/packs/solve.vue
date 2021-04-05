<template>
  <div id="app panel">
    <div v-if="drill" class="solve-drill">
      <span class="drill-id"> drill-ID：{{ drill.id }} </span>
      <div class="solve-drill-title"> {{ drill.title }} </div>
    </div>
    <div v-if="state=='solving'">
      <div class="problem">
        <div v-if="currentProblem">
          <span class="problem-id"> problem-ID:{{ currentProblem.id }} </span>
          <div class="problem-index"> {{ currentProblemIndex + 1 }}問目 </div>
          <div class="problem-title"> {{ currentProblem.title }} </div>
          <div class="problem-statement" v-html="compiledMarkdown(currentProblem.statement)"></div>
          <ol class="problem-choices">
            <li
              v-for="(choice, choiceNo) in currentProblem.choices"
              :key="choiceNo"
              class="problem-choice"
              :class="{'selected-choice': answerPaper[currentProblem.id] === choiceNo}"
              @click="selectOption(choiceNo)"
              v-html="compiledMarkdown(choice)"
            >
            </li>
            <li
              class="problem-choice"
              :class="{'selected-choice--not-sure': answerPaper[currentProblem.id] === 'notSure'}"
              @click="selectOption('notSure')"
            >
              　わからない
            </li>
          </ol>
        </div>
        <div class="move-buttons">
          <div v-if="0 < currentProblemIndex" class="btn-prev-frame"><button @click="prevProblem()" class="btn-prev btn-std">次の問題へ</button></div>
          <div v-if="currentProblemIndex < problems.length - 1" class="btn-grade-frame"><button @click="grade()" class="btn-std">中断して採点する</button></div>
          <div v-if="currentProblemIndex == problems.length - 1" class="btn-grade-frame"><button @click="grade()" class="btn-std">採点する</button></div>
          <div v-if="currentProblemIndex < problems.length - 1" class="btn-next-frame"><button @click="nextProblem()" class="btn-next btn-std">次の問題へ</button></div>
        </div>
      </div>
    </div>
    <div v-else-if="state=='result'">
      <a :href="resolveDrillURL" class="btn-std button-link">解き直す</a>
      <a href="/drills" class="btn-std button-link">ドリル一覧に戻る</a>
      <div>今回の正解数: {{ correct_count }} </div>
      <div>今回の不正数: {{ uncorrect_count }} </div>
      <div>今回のわからない・無回答: {{ problems.length - correct_count - uncorrect_count }} </div>
      <div>今回の出題数: {{ problems.length }} </div>
      <div>今回の正解率: {{ Math.floor(correct_count / problems.length * 100) }}%</div>
      <ol>
        <li v-for="(problem, problem_idx) in problems" :key="problem_idx" class="panel">
          <div class="problem-id"> 問題ID{{ problem.id }} </div>
          <div class="problem-title" v-if="problem.title"> {{ problem.title }} </div>
          <div class="problem-statement" v-html="compiledMarkdown(problem.statement)"> </div>
          <div class="problem-correct_option"> 正解: {{ problem.correct_option + 1 }}. <span v-html="compiledMarkdown(problem.choices[problem.correct_option])"></span> </div>
          <div class="problem-correct_option" v-if="answerPaper[problem.id] >= 0"> 回答: {{ answerPaper[problem.id] + 1 }}. <span v-html="compiledMarkdown(problem.choices[answerPaper[problem.id]])"></span> </div>
          <div class="problem-correct_option" v-else> 無回答 </div>
          <div style="font-size: 1.2em;">
            <span v-if="!answerPaper[problem.id]" class="uncorrect">無回答でした</span>
            <span v-else-if="problem.correct_option===answerPaper[problem.id]" class="correct">正解です</span>
            <span v-else class="uncorrect">不正解です</span>
          </div>
          <div class="problem-statement" v-html="compiledMarkdown(problem.explanation)" v-if="problem.explanation.length > 0"> </div>
        </li>
      </ol>
      <a :href="resolveDrillURL" class="btn-std button-link">解き直す</a>
      <a href="/drills" class="btn-std button-link">ドリル一覧に戻る</a>
    </div>
  </div>
</template>

<script>
import marked from 'marked';
import hljs from 'highlight.js';

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

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
      notSure_count: 0,
      uncorrect_count: 0,
    }
  },
  created() {
    marked.setOptions({
      langPrefix: 'hljs ',
      sanitize: true,
      gfm: false,
      breaks: false,
      // highlightjsを使用したハイライト処理を追加
      highlight: function(code, lang) {
        return hljs.highlightAuto(code, [lang]).value
      }
    });

    history.pushState(null, null, location.href);
    window.onpopstate = () => {
      history.go(1)
    }

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
      // console.log(`selectOption Method ${choiceNo}`);
      this.currentProblem.selectIndex = choiceNo;
      sleep(100);
      this.answerPaper[this.currentProblem.id] = choiceNo;
      console.log(this.answerPaper);
      if(0 <=  this.currentProblemIndex && this.currentProblemIndex < this.problems.length - 1) {
        this.currentProblemIndex += 1;
        this.currentProblem = this.problems[this.currentProblemIndex];
      } else if (this.currentProblemIndex == this.problems.length - 1) {
        // console.log("最後の問題です");
      } else if (this.currentProblemIndex < 0 || this.problems.length - 1 < this.currentProblemIndex) {
        // console.log("問題番号が0未満になっているか、超越してます");
      }
    },
    grade() {
      console.log("method grade");
      console.log(this.answerPaper);
      this.postAnswerPaper();
      this.correct_count = 0
      for(let i = 0; i < this.problems.length; i++){
        let problem = this.problems[i];
        // console.log([problem.id])
        if(this.answerPaper[problem.id] == problem.correct_option){
          this.correct_count += 1
        } else if(this.answerPaper[problem.id] === "notSure" ){
          this.notSure_count += 1
        } else if(this.answerPaper[problem.id] && this.answerPaper[problem.id] && problem.correct_option){
          this.uncorrect_count += 1
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
        // console.log(json)
        // console.log("posted Answer Paper")
      }).catch(error => {
        console.warn('Failed to parsing', error)
      })
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
    },
  },
  computed: {
    resolveDrillURL() {
      return location.href
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
  font-weight: bold;
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

.drill-id, .problem-id {
  color: hsl(0, 10%, 80%);
}

.problem-title {
  /* width: 800px; */
  /* border: solid 1px #eee; */
  /* background-color: #fff; */
}

.problem-statement {
  /* width: 800px; */
  /* border: solid 1px #eee; */
  padding: 16px;
  /* overflow-wrap: break-word; */
  /* background-color: #fff; */
}

.problem-choices {
  margin: 0;
}

.problem-choice {
  /* width: 800px; */
  border: solid 1px #eee;
  border-radius: 4px;
  background-color: #e1e1e1;
  cursor: pointer;
  margin: 8px;
  padding: 8px;
}

.problem-choice.selected-choice {
  background-color: hsl(103, 85%, 50%);
}

.problem-choice.selected-choice--not-sure {
  background-color: hsl(220, 85%, 50%);
}

.problem-choice:hover {
  background-color: #efefef;
}

.problem-choice.selected-choice:hover {
  background-color: hsl(103, 85%, 80%);
}

.problem-choice.selected-choice--not-sure:hover {
  background-color: hsl(220, 85%, 80%);
}


.problem-explanation {
  /* width: 800px; */
  /* border: solid 1px #eee; */
  /* background-color: #fff; */
}

p {
  font-size: 2em;
  text-align: center;
}

.move-buttons {
  margin: 16px;
  display: grid;
  grid-template-rows: 1fr;
  grid-template-columns: 4fr 5fr 4fr;
  justify-content: space-between;
}

.btn-prev-frame {
  grid-row: 1;
  grid-column: 1;
}

.btn-grade-frame {
  grid-row: 1;
  grid-column: 2;
  justify-self: center;
}

.btn-next-frame {
  grid-row: 1;
  grid-column: 3;
  justify-self: end;
}

.correct {
  color: var(--correct-color);
}

.uncorrect {
  color: var(--uncorrect-color);
}

</style>
