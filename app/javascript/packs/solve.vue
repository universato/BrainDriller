<template>
  <div id="app panel">
    <div v-if="drill" class="solve-drill">
      <div class="solve-drill-title"> {{ drill.title }} </div>
    </div>
    <div v-if="state=='solving'">
      <div class="w-100 text-center">
        <span v-for="(el, i) in answerStatus" :key="i">
          <span v-if="el=='notSure'"> ・ </span>
          <span v-else-if="el >= 0" class="text-success">✓</span>
          <span v-else> − </span>
        </span>
      </div>
      <div class="problem">
        <div v-if="currentProblem">
          <span class="problem-id" v-if="false"> problem-ID:{{ currentProblem.id }} </span>
          <div class="problem-index fs-3"> {{ currentProblemIndex + 1 }}問目 </div>
          <div v-if="currentUserId" class="text-muted">
            <div>あなたの連続正解数: {{ currentStreak }} 回</div>
            <div>あなたの回答回数: {{ numberOfSubmissions }} 回</div>
            <div>あなたの正解回数: {{ numberOfCorrectAnswers }} 回</div>
            <div>あなたの正解率: {{ percent(numberOfCorrectAnswers, numberOfSubmissions) }} % </div>
          </div>
          <div class="problem-title"> {{ currentProblem.title }} </div>
          <div class="problem-statement" v-html="compiledMarkdown(currentProblem.statement)"></div>
          <div class="problem-choices">
            <div
              v-for="(choice, choiceNo) in currentProblem.choices"
              :key="choiceNo"
              class="problem-choice"
              :class="{'selected-choice': answerPaper[currentProblem.id] === choiceNo}"
              @click="selectOption(choiceNo)"
              v-html="compiledMarkdown(choice)"
            >
            </div>
            <div
              class="problem-choice"
              :class="{'selected-choice--not-sure': answerPaper[currentProblem.id] === 'notSure'}"
              @click="selectOption('notSure')"
            >
              　わからない
            </div>
          </div>
        </div>
        <div class="move-buttons">
          <div v-if="0 < currentProblemIndex" class="btn-prev-frame"><button @click="prevProblem()" class="btn-prev btn-std p-3 fs-4">前の問題へ</button></div>
          <div v-if="currentProblemIndex < problems.length - 1" class="btn-grade-frame"><button @click="grade()" class="btn-std p-3 fs-4">中断して採点する</button></div>
          <div v-if="currentProblemIndex == problems.length - 1" class="btn-grade-frame"><button @click="grade()" class="btn-std p-3 fs-4">採点する</button></div>
          <div v-if="currentProblemIndex < problems.length - 1" class="btn-next-frame"><button @click="nextProblem()" class="btn-next btn-std p-3 fs-4">次の問題へ</button></div>
        </div>
      </div>
    </div>
    <div v-else-if="state=='result'">
      <a :href="resolveDrillURL" class="btn btn-primary w-100 fs-4 my-3">解き直す</a>
      <div>
        <div class="bg-light p-5 my-4 rounded">
          <h3>サマリー</h3>
          <span v-for="(problem, problem_idx) in problems" :key="problem_idx">
            <span v-if="answerPaper[problem.id] === undefined">-</span>
            <span
              v-else-if="problem.correct_option===answerPaper[problem.id]"
              class="text-success"
            >○</span>
            <span v-else-if="answerPaper[problem.id]==='notSure'">.</span>
            <span v-else class="text-danger">✗</span>
          </span>
          <div> 回答時間{{ elaspedTime }} </div>
          <div>今回の正解数: {{ correct_count }} </div>
          <div>今回の不正数: {{ uncorrect_count }} </div>
          <div>今回のわからない・無回答: {{ problems.length - correct_count - uncorrect_count }} </div>
          <div>今回の出題数: {{ problems.length }} </div>
          <div>今回の正解率: {{ Math.floor(correct_count / problems.length * 100) }}%</div>
        </div>
      </div>
      <div>
        <div v-for="(problem, problem_idx) in problems" :key="problem_idx" class="bg-light p-5 my-4 rounded">
          <h3>{{ problem_idx + 1 }} 問目</h3>
          <div class="problem-id" v-if="false"> Problem ID{{ problem.id }} </div>
          <div class="problem-title" v-if="problem.title"> {{ problem.title }} </div>
          <div class="problem-statement" v-html="compiledMarkdown(problem.statement)"> </div>
          <div
            v-for="(choice, choiceNo) in problem.choices"
            :key="choiceNo"
            class="problem-choice"
            :class="markedChoice(choiceNo, problem.correct_option, answerPaper[problem.id])"
          >
            <span v-html="compiledMarkdown(choice)"></span>
          </div>
          <div class="problem-correct_option"> 正解: {{ problem.correct_option + 1 }}. <span v-html="compiledMarkdown(problem.choices[problem.correct_option])"></span> </div>
          <div class="problem-correct_option" v-if="answerPaper[problem.id] >= 0"> 回答: {{ answerPaper[problem.id] + 1 }}. <span v-html="compiledMarkdown(problem.choices[answerPaper[problem.id]])"></span> </div>
          <div class="problem-correct_option" v-else> 無回答 </div>
          <div style="font-size: 1.2em;">
            <span v-if="answerPaper[problem.id] === undefined" class="uncorrect">無回答でした</span>
            <span v-else-if="problem.correct_option===answerPaper[problem.id]" class="text-success">正解です</span>
            <span v-else class="text-danger">不正解です</span>
          </div>
          <div class="problem-statement" v-html="compiledMarkdown(problem.explanation)" v-if="problem.explanation.length > 0"> </div>
        </div>
      </div>
      <a :href="resolveDrillURL" class="btn btn-primary w-100 fs-4 py-3 mt-1">解き直す</a>
    </div>
  </div>
</template>

<script>
import marked from 'marked';
import DOMPurify from 'dompurify';
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
      problemMap: {},
      state: "solving",
      currentProblem: null,
      answerPaper: {},
      correct_count: 0,
      notSure_count: 0,
      uncorrect_count: 0,
      answerStatus: [],
      startTime: new Date(),
      endTime: new Date(),
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

    history.pushState(null, null, location.href);
    window.onpopstate = () => {
      history.go(1)
    }

    const pathnames = location.pathname.split('/'); // ["", "solve", "5"]
    const drill_id = pathnames[2];
    const url = new URL(location.href);
    console.log(`/api/drills/${drill_id}.json${url.search}`);
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
      this.problems = json.problems
      this.problemMap = json.problemMap
      console.log(json.currentUserId)
      console.log(this.problemMap);
      this.currentUserId = json.currentUserId
      this.currentProblem = this.problems[0];
      let n = Object.keys(this.problems).length;
      this.answerStatus = new Array(n)
    }).catch(error => {
      console.warn('Failed to parsing', error)
    })
  },
  methods: {
    selectOption(choiceNo) {
      this.currentProblem.selectIndex = choiceNo;
      this.answerPaper[this.currentProblem.id] = choiceNo;
      this.answerStatus[this.currentProblemIndex] = choiceNo;
      sleep(100); // <- すぐに切り替わるといきなりすぎるかと思って、少し待機。
      if(0 <=  this.currentProblemIndex && this.currentProblemIndex < this.problems.length - 1) {
        this.currentProblemIndex += 1;
        this.currentProblem = this.problems[this.currentProblemIndex];
      }
    },
    grade() {
      this.endTime = new Date();
      console.log("method grade");
      console.log(this.answerPaper);
      this.postAnswerPaper();
      this.correct_count = 0
      for(let i = 0; i < this.problems.length; i++){
        let problem = this.problems[i];
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
        drill_id: this.drill.id,
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
      return DOMPurify.sanitize(marked(md));
    },
    percent(a, b) {
      // `${a / b * 100}`; percent(20, 100) //=> 20.0
      if(b === 0){
        return "-"
      }else{
        return (Math.round(a / b * 1000) / 10).toFixed(1);
      }
    },
    markedChoice(choiceNo, correctNo, selectedNo){
      if(choiceNo === correctNo && correctNo === selectedNo){
        // 選ばれた正解
        return `selected-correct-choice bg-success`
      }else if(choiceNo === correctNo){
        // 選ばれなかった正解
        return `correct-choice bg-info`
      }else if(choiceNo === selectedNo) {
        // 選ばれた不正解
        return `selected-uncorrect-choice bg-danger`
      }else {
        return ``
      }
    }
  },
  computed: {
    resolveDrillURL() {
      return `/drills/${this.drill.id}`
    },
    currentStreak() {
      let problemId = this.currentProblem.id;
      if(this.problemMap && this.problemMap.hasOwnProperty(problemId)){
        return this.problemMap[problemId].current_streak;
      }else{
        return 0;
      }
    },
    numberOfSubmissions() {
      let problemId = this.currentProblem.id;
      if(this.problemMap && this.problemMap.hasOwnProperty(problemId)){
        return this.problemMap[problemId].number_of_submissions;
      }else{
        return 0;
      }
    },
    numberOfCorrectAnswers() {
      let problemId = this.currentProblem.id;
      if(this.problemMap && this.problemMap.hasOwnProperty(problemId)){
        return this.problemMap[problemId].number_of_correct_answers;
      }else{
        return 0;
      }
    },
    elaspedTime() {
      let ms = this.endTime - this.startTime;
      let seconds = Math.floor(ms / 1000);
      let minutes = Math.floor(seconds / 60);
      let second = seconds % 60;
      if (minutes > 0){
        return `${minutes}分 ${second}秒 (=${seconds}秒)`
      } else {
        return `${seconds}秒`
      }
    },
  }
}
</script>

<style scoped>

.solve-drill {
  border: none 0 #fff;
  border-radius: 4px;
  background-color: #fff;
}

.solve-drill-title {
  font-weight: bold;
  background-color: #fff;
}

.panel {
  background-color: #fafafa;
}

.problem {
  margin: 8px 0 8px;
  padding: 8px 0 8px;
  border: none 0 #fff;
  border-radius: 4px;
  background-color: #fff;
}

.drill-id, .problem-id {
  color: hsl(0, 10%, 80%);
}

.problem-title {
  padding: 8px 0 8px;
}

.problem-statement {
  padding: 16px 0;
}

.problem-choices {
  border-top: 1px solid #ccc;
  margin-top: 8px;
  margin-left: 0;
}

.problem-choice {
  border: solid 1px #eee;
  border-radius: 4px;
  background-color: #e1e1e1;
  cursor: pointer;
  margin-top: 8px;
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

p {
  font-size: 2em;
  text-align: center;
}

.move-buttons {
  margin-top: 16px;
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
