<template>
  <div id="app">
    <p>{{ message }}</p>
    <div v-if="drill">
      <div class="drill-id"> ドリルID：{{ drill.id }} </div>
      <div class="drill-title"> ドリルのタイトル： {{ drill.title }} </div>
    </div>
    <div class="problems">
      <div v-if="currentProblem">
        <div class=problem>{{ currentProblem }}</div>
        <div class="problem-id"> 問題ID{{ currentProblem.id }} </div>
        <div class="problem-id"> {{ currentProblemIndex +1 }}問目 </div>
        <div class="problem-title"> {{ currentProblem.title }} </div>
        <div class="problem-statement"> {{ currentProblem.statement }} </div>
        <ol class="problem-choices">
          <li
            v-for="(choice, idx) in currentProblem.choices"
            :key="idx"
            class="problem-choice"
          >
            {{ choice }}
          </li>
        </ol>
      </div>
      <div v-if="0 < currentProblemIndex"><button @click="prevProblem()">前のクイズへ</button></div>
      <div v-if="currentProblemIndex < problems.length - 1"><button @click="nextProblem()">次のクイズへ</button></div>
      <div class="problem" v-for="(problem, problemNo) in problems" :key="problem.id">
        <div>Problem ID{{ problem.id }}</div>
        <div>{{ problemNo + 1 }}番目の問題</div>
        <div>全{{ problems.size }}問</div>
        <div class="problem-title"> {{ problem.title }} </div>
        <div class="problem-statement">{{ problem.statement }}</div>
        <ol class="problem-choice">
          <li
            class="choice"
            v-for="(choice, choiceNo) in problem.choices"
            :key="choice.id"
            @click="selectOption(choiceNo)"
          >
            {{ choice }}
          </li>
        </ol>
        {{ problem.correct_option }}
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      currentProblemIndex: 0,
      message: "問題を解いています！",
      drill: null,
      problems: [],
      currentProblem: null,
      answerPaper: {},
    }
  },
  created() {
    fetch("/api/drills/1.json", {
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
      this.answerPaper[this.currentProblemIndex] = choiceNo;
      console.log(this.answerPaper)
    },
    nextProblem() {
      if(this.problems.size - 1 <= this.currentProblemIndex) { return }
      this.currentProblemIndex += 1;
      this.currentProblem = this.problems[this.currentProblemIndex];
    },
    prevProblem() {
      if(this.currentProblemIndex <= 0) { return }
      this.currentProblemIndex -= 1;
      this.currentProblem = this.problems[this.currentProblemIndex];
    }
  }
}
</script>

<style scoped>

.drill-title {
  width: 800px;
  border: solid 1px #eee;
}

.problem-title {
  width: 800px;
  border: solid 1px #eee;
}

.problem-statement {
  width: 800px;
  border: solid 1px #eee;
}

.problem-choice {
  width: 800px;
  border: solid 1px #eee;
}

p {
  font-size: 2em;
  text-align: center;
}
</style>
