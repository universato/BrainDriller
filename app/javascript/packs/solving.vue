<template>
  <div id="app">
    <p>{{ message }}</p>
    <div class="problems">
      <div class="problem" v-for="(problem, problemNo) in problems" :key="problem.id">
        <div>Problem ID{{ problem.id }}</div>
        <div>{{ problemNo + 1 }}番目の問題</div>
        <div>全{{ problems.size }}問</div>
        <div class="problem-title"> {{ problem.title }} </div>
        <div class="problem-statement">{{ problem.statement }}</div>
        <ol class="choice">
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
      problems: [],
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
      this.problems = []
      json.problems.forEach(r => { this.problems.push(r) })
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
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
