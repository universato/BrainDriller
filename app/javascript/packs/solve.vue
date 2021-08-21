<template>
  <div class="problem-panel">
    <div v-if="state=='solving'">
      <div v-if="drill && false" class="solve-drill">
        <div class="solve-drill-title"> {{ drill.title }} </div>
      </div>
      <div class="problem">
        <div class="status-blocks">
          <div
            v-for="(el, problemIndex) in answerStatus"
            :key="problemIndex"
            :class="statusClass(el, problemIndex)"
            @click="setCurrentProblemIndex(problemIndex)"
          >
          </div>
        </div>
        <div v-if="currentProblem" class="problem-main">
          <span class="problem-id" v-if="false"> problem-ID:{{ currentProblem.id }} </span>
          <div v-if="currentUserId && false" class="text-muted">
            <div>あなたの連続正解数: {{ currentStreak }} 回</div>
            <div>あなたの回答回数: {{ numberOfSubmissions }} 回</div>
            <div>あなたの正解回数: {{ numberOfCorrectAnswers }} 回</div>
            <div>あなたの正解率: {{ percent(numberOfCorrectAnswers, numberOfSubmissions) }} % </div>
          </div>
          <div class="problem-idnex-and-title fs-2">
            <span class="problem-index"> {{ currentProblemIndex + 1 }}問目 </span>
            <span class="problem-title"> {{ currentProblem.title }} </span>
          </div>
          <div class="problem-statement" v-html="compiledMarkdown(currentProblem.statement)"></div>
          <div class="problem-choices">
            <div
              v-for="(choice, choiceNo) in currentProblem.choices"
              :key="choiceNo"
              class="problem-choice"
              :class="answerPaper[currentProblem.id] === choiceNo ? 'selected-choice' : 'unselected-choice'"
              @click="selectOption(choiceNo)"
              v-html="compiledMarkdown(choice)"
            >
            </div>
            <div
              class="problem-choice"
              :class="answerPaper[currentProblem.id] === 'notSure' ? 'selected-choice--not-sure' : 'unselected-choice'"
              @click="selectOption('notSure')"
            >
              わからない
            </div>
          </div>
          <div class="move-buttons">
            <div v-if="0 < currentProblemIndex" class="btn-prev-frame"><button @click="prevProblem()" class="btn-prev-or-next p-3 fs-4">前の問題へ</button></div>
            <div v-if="Object.keys(answerStatus).length < problems.length" class="btn-grade-frame"><button @click="grade()" class="btn-grade-in-the-middle text-center p-3 fs-4">未回答を残して採点する</button></div>
            <div v-else class="btn-grade-frame"><button @click="grade()" class="btn-grade p-3 fs-4">採点する</button></div>
            <div v-if="currentProblemIndex < problems.length - 1" class="btn-next-frame"><button @click="nextProblem()" class="btn-prev-or-next p-3 fs-4">次の問題へ</button></div>
          </div>
        </div>
      </div>
    </div>
    <div v-else-if="state=='result'">
      <div>
        <div class="bg-light p-5 my-4 rounded">
          <div>
            <span class="result-summary-title">今回の結果　</span>
            <span v-for="(problem, problemIdx) in problems" :key="problemIdx" class="fs-2 ml-5">
              <span v-if="answerPaper[problem.id] === undefined">- </span>
              <span
                v-else-if="problem.correct_option===answerPaper[problem.id]"
                class="text-correct"
              >○ </span>
              <span v-else-if="answerPaper[problem.id]==='notSure'">. </span>
              <span v-else class="text-danger">✗ </span>
            </span>
          </div>
          <div class="result-stats">
            <div><div class="result-label text-center">回答時間</div><div class="result-data" v-html="elaspedTime"></div></div>
            <div><div class="result-label text-center">出題数</div><div class="result-data"> {{ problems.length }} <span class="fs-3">問</span> </div> </div>
            <div><div class="result-label text-center">正解数</div><div class="result-data"> {{ correct_count }} <span class="fs-3">問</span></div> </div>
            <div><div class="result-label text-center">不正解数</div> <div class="result-data"> {{ problems.length - correct_count }} <span class="fs-3">問</span></div> </div>
            <div><div class="result-label text-center">正解率</div> <div class="result-data"> {{ Math.floor(correct_count / problems.length * 100) }}<span class="fs-3">%</span></div></div>
          </div>
        </div>
      </div>
      <a :href="resolveDrillURL" class="btn btn-primary w-100 fs-4 my-3">すぐに解き直す</a>
      <div>
        <div v-for="(problem, problemIdx) in problems" :key="problemIdx" class="bg-light p-5 my-4 rounded problem-panel">
          <div class="problem-idnex-and-title fs-2">
            <span class="problem-index"> {{ problemIdx + 1 }}問目 </span>
            <span class="problem-title"> {{ problem.title }} </span>
          </div>
          <div class="problem-id" v-if="false"> Problem ID{{ problem.id }} </div>
          <div class="problem-statement" v-html="compiledMarkdown(problem.statement)"> </div>
          <div
            v-for="(choice, choiceNo) in problem.choices"
            :key="choiceNo"
            class="problem-choice"
            :class="markedChoice(choiceNo, problem.correct_option, answerPaper[problem.id])"
          >
            <span v-html="compiledMarkdown(choice)"></span>
          </div>
          <div v-if="false">
            <div class="problem-correct_option"> 正解: {{ problem.correct_option + 1 }}. <span v-html="compiledMarkdown(problem.choices[problem.correct_option])"></span> </div>
            <div class="problem-correct_option" v-if="answerPaper[problem.id] >= 0"> 回答: {{ answerPaper[problem.id] + 1 }}. <span v-html="compiledMarkdown(problem.choices[answerPaper[problem.id]])"></span> </div>
            <div class="problem-correct_option" v-else> 無回答 </div>
          </div>
          <div class="text-center fs-2 mt-5">
            <span v-if="answerPaper[problem.id] === undefined" class="uncorrect">ー 無回答</span>
            <span v-else-if="problem.correct_option===answerPaper[problem.id]" class="text-correct">○ 正解</span>
            <span v-else class="text-danger">✗ 不正解</span>
          </div>
          <div v-if="problem.explanation.trim().length > 0">
            <h4 class="fs-2">【解説】</h4>
            <div class="problem-explanation mt-2 fs-4" v-html="compiledMarkdown(problem.explanation)" v-if="problem.explanation.length > 0"> </div>
          </div>
          <div v-else>
            <h4 class="fs-2">解説なし</h4>
          </div>
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
      console.log(this.answerStatus)
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
        return `selected-correct-choice bg-correct`
      }else if(choiceNo === correctNo){
        // 選ばれなかった正解
        return `correct-choice bg-correct`
      }else if(choiceNo === selectedNo) {
        // 選ばれた不正解
        return `selected-uncorrect-choice bg-danger`
      }else {
        return `normal-choice`
      }
    },
    statusClass(el, problemIndex) {
      let statusClass = "";
      if(this.currentProblemIndex !== problemIndex){
        statusClass = "pe-pointer "
      }
      if(el==="notSure"){
        return statusClass + "status-block status-not_sure"
      }else if(el>=0){
        return statusClass + "status-block status-checked"
      }else{
        return statusClass + "status-block status-unchecked"
      }
    },
    setCurrentProblemIndex(problemIndex) {
      this.currentProblemIndex = problemIndex;
      this.currentProblem = this.problems[problemIndex];
    },
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
        return `${minutes}<span class="fs-3">分<span>${second}<span class="fs-3">秒<span>`
      } else {
        return `${seconds}<span class="fs-3">秒<span>`
      }
    },
  }
}
</script>

<style>

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
  margin: 0 0 8px;
  padding: 0px 0 8px;
  border: none 0 #fff;
  border-radius: 4px;
  background-color: #fff;
}

.problem-panel {
  background: #FFFFFF;
  box-shadow: 0px 8px 24px rgba(0, 102, 255, 0.25);
  border-radius: 20px;
}

.drill-id, .problem-id {
  color: hsl(0, 10%, 80%);
}

.problem-main {
  margin: 20px 8% 0;
}

.problem-idnex-and-title {
  /* width: 151px; */
  height: 35px;

  font-family: Noto Sans JP;
  font-style: normal;
  font-weight: normal;
  font-size: 24px;
  line-height: 35px;
  /* identical to box height */

  color: #222222;
}

.problem-statement {
  padding: 16px 0;
  font-size: 18px;
}

.problem-choices {
  border-top: 1px solid #ccc;
  margin-top: 8px;
  margin-left: 0;
}

.problem-choice {
  border: solid 1px #eee;
  border-radius: 4px;
  /* background-color: #e1e1e1; */
  cursor: pointer;
  margin-top: 8px;
  padding: 8px;
}

.problem-choice.normal-choice {
  background-color: #e1e1e1;
}

.problem-choice.unselected-choice {
  background-color: #e1e1e1;
}

.problem-choice.selected-choice {
  /* border: 1px solid hsl(216, 100%, 50%, 0.8); */
  background-color: hsl(216, 100%, 50%, 0.8);
}

.problem-choice.selected-choice--not-sure {
  background-color: hsla(59, 88%, 80%, 0.82);
}

.problem-choice.unselected-choice:hover {
  background-color: #efefef;
}

.problem-choice.selected-choice:hover {
  background-color: hsl(216, 100%, 80%, 0.8);
}

.problem-choice.selected-choice--not-sure:hover {
  background-color: hsla(59, 88%, 90%, 0.82);
}

.result-summary-title {
  width: 160px;
  height: 46px;

  font-family: "Noto Sans JP";
  font-style: normal;
  font-weight: bold;
  font-size: 32px;
  line-height: 46px;

  color: #222222;
}

.result-stats {
  display: flex;
  justify-content: space-between;
}

.result-label {
  /* display: flex;
  flex-direction: row;
  align-items: flex-start; */
  padding: 4px 8px;

  /* width: 72px; */
  height: 28px;

  background: #EEEEEE;
  border-radius: 4px;
}

.result-data {
  width: 120px;
  height: 41px;

  font-family: "Noto Sans JP";
  font-style: normal;
  font-weight: 500;
  font-size: 28px;
  line-height: 41px;
  /* identical to box height */

  text-align: center;
  color: #222222;
}

.status-blocks {
  display: flex;
  justify-content: space-between;
}

.status-block {
  flex: 1;
  height: 16px;
  margin: 4px;
  box-shadow: 0px 6px 12px rgba(0, 102, 255, 0.25);
}

.status-not_sure {
  background: #f9f7a1d1;
}

.status-checked {
  background: #0066FF;
}

.status-unchecked {
  background: #FFFFFF;
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

.problem-statement code  {
  margin-left: 4px;
  margin-right: 4px;
  background-color: #eeeeee;
}

.problem-statement code.hljs  {
  background-color: #364549;
}

.problem-explanation code  {
  margin-left: 4px;
  margin-right: 4px;
  background-color: #eeeeee;
}

.problem-explanation code.hljs  {
  background-color: #364549;
}

</style>
