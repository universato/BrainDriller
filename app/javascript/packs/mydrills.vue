<template>
  <div id="app panel">
    <div v-if="isLoaded">
      <div v-if="drills.length === 0">
        現在、あなたがマイドリルとして登録されているドリルはありません。
      </div>
      <div v-else>
        <button @click="reverseDrills" class="btn btn-primary">逆順する</button>
        <button @click="sortUnmasteredDrills" class="btn btn-primary">{{ drillReversed ? "未習得率順" : "習得率順" }}</button>
        <div v-for="drill in drills" :key="drill.id">
          タイトル: {{ drill.title }}
          全体閲覧数{{ drill.number_of_views }}
          ドリルID{{ drill.id }}
          習得数{{ number_of_problem_mastered(drill.id) }}
          習得数{{ drill.problem_size }}
          習得率{{ percent(number_of_problem_mastered(drill.id), drill.problem_size) }}%
          <br>
          <div v-if="likes[drill.id]">
            <button @click="unlikeDrill(drill)" class="btn btn-primary">Unlike Drill</button>
          </div>
          <div v-else>
            <button @click="likeDrill(drill)" class="btn btn-primary">Like Drill</button>
          </div>
        </div>
      </div>
    </div>
    <div v-else>
      <div>ロード中</div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      drills: [],
      likes: {},
      drillReversed: false,
      isLoaded: false,
    }
  },
  created() {
    fetch(`/api/mydrills.json`, {
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
      this.drills =  json.drills
      this.drills.forEach((drill) => {
        this.likes[drill.id] = true;
      })
      this.drill_user_result =  json.drill_user_result
    }).catch(error => {
      console.warn('Failed to parsing', error)
    })
    this.isLoaded = true;
  },
  methods: {
    number_of_problem_mastered(drill_id) {
      if (this.drill_user_result[drill_id]){
        return this.drill_user_result[drill_id].number_of_problem_mastered;
      } else {
        return 0;
      }
    },
    likeDrill(drill) {
      this.likes[drill.id] = true;
      const params = {
        drill_id: drill.id
      }
      fetch(`/drill_likes`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': this.token
        },
        credentials: 'same-origin',
        redirect: 'manual',
        body: JSON.stringify(params)
      }).then(response => {
        // return response.json()
      }).then(json=> {
      }).catch(error => {
        console.warn('Failed to parsing', error)
      })
    },
    unlikeDrill(drill) {
      this.likes[drill.id] = false;
      // const params = {
      //   drill_id: drill.id
      // }
      console.log(drill.id)
      console.log(`/api/drill_likes/${drill.id}`)
      fetch(`/api/drill_likes/${drill.id}`, {
        method: 'DELETE',
        headers: {
          // 'Content-Type': 'application/json; charset=utf-8',
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': this.token
        },
        credentials: 'same-origin',
        redirect: 'manual',
        // body: JSON.stringify(params)
      }).then(response => {
        console.log(response);
        // return response.json()
      }).then(json=> {
      }).catch(error => {
        console.warn('Failed to parsing', error)
      })
    },
    percent(a, b) {
      // `${a / b * 100}`; percent(20, 100) //=> 20.0
      if(b === 0){
        return "-"
      }else{
        return (Math.round(a / b * 1000) / 10).toFixed(1);
      }
    },
    reverseDrills() {
      this.drills.reverse();
    },
    sortUnmasteredDrills() {
      let p1, p2;
      this.drills.sort((drill1, drill2) => {
        p1 = this.percent(this.number_of_problem_mastered(drill1.id), drill1.problem_size);
        p2 = this.percent(this.number_of_problem_mastered(drill2.id), drill2.problem_size);
        return p1 - p2;
      })
      this.drillReversed = !this.drillReversed;
      if (this.drillReversed) { this.drills.reverse(); }
    }
  },
  computed: {
    token () {
      const meta = document.querySelector('meta[name="csrf-token"]')
      return meta ? meta.getAttribute('content') : ''
    }
  }
}
</script>

<style scoped>
.statement {
  width: 80%;
}

.explanation {
  width: 80%;
}
</style>
