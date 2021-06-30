<template>
  <div id="app">
    <p>{{ message }}</p>
    <div class="row">
      <div class="col-md-6 col-md-offset-3">
        <label for="drill_title">ドリルのタイトル</label>
        <input v-model="drillTitle" type="text" name="drill[title]" id="drill_title" class="drill-title form-title" />

        <div>ガイド</div>
        <textarea v-model="drillGuide" placeholder="" class="drill-guide form-title"></textarea>

        <ul>
          <li v-for="(problem, idx) in problems" :key="problem.id">
            <label>問題のタイトル</label>
            <input v-model="problem.title" name="problem[title]" class="problem-title" />
            <textarea v-model="problem.statement" class="problem-statement"></textarea>
            <ol>
              <li
                v-for="(choice) in problem.choices"
                :key="choice"
              >
                <input :value="choice" class="choice-input">
              </li>
            </ol>
            <div @click="addProblem(idx)">
              + 問題を追加する
            </div>
          </li>
        </ul>

        <div @click="createDrill()" class="btn btn-primary">
          作成する
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      drillTitle: "",
      drillGuide: "",
      message: "ドリル作成",
      problems: [{id: null, title: '', statement: '', choices: ["選択肢1", "選択肢2", "選択肢3", "選択肢4"] }],
      message: '',
    }
  },
  watch: {
    problems: {
      handler: function(val, oldVal) {
        // alert('')
      },
      deep: true
    }
  },
  created() {
  },
  methods: {
    addProblem(idx) {
      const n = this.problems.length
      const problem = {
        id: n,
        title: `aaaaaaaaaa${n}`,
        statement: 'bbbbbbbbbb',
        choices: ["選択肢1", "選択肢2", "選択肢3", "選択肢4"],
      }
      this.problems.splice(idx + 1, 0, problem)
      // this.problems.push(problem)
      console.log("問題を追加しました")
    },
    createDrill() {
      console.log("createDrill")
      console.log(this.token);
      const params = {
        drillTitle: this.drillTitle,
        drillGuide: this.drillGuide,
        problems: this.problems
      }
      fetch(`/drills`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': this.token
        },
        credentials: 'same-origin',
        redirect: 'manual',
        body: JSON.stringify(params)
      })
        .then(response => {
          // return response.json()
        })
        .then(json=> {
        })
        .catch(error => {
          console.warn('Failed to parsing', error)
        })
    },
  },
  computed: {
    token () {
      const meta = document.querySelector('meta[name="csrf-token"]')
      return meta ? meta.getAttribute('content') : ''
    },
  }
}
</script>

<style scoped>
.drill-title {
  width: 480px;
}

.drill-guide {
  height: 160px;
  width: 800px;
}

.problem-title {
  width: 480px;
}

.problem-statement {
  height: 160px;
  width: 800px;
}

.choice-input {
  width: 560px;
}

p {
  font-size: 2em;
  text-align: center;
}
</style>
