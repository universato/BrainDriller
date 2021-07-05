<template>
  <div id="app">
    {{  }}
  </div>
</template>

<script>
// ドリルのみんなの習得率などを書きたいかも。
export default {
  data() {
    return {
      drillMap: null,
      msg: "js-drill-info"
    }
  },
  created() {
    return
    const pathnames = location.pathname.split('/'); // ["", "drills", "5"]
    const drill_id = pathnames[2];
    const url = new URL(location.href);

    fetch(`/api/drill-info/${drill_id}.json`, {
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
      this.drillMap =  json.drillMap
    }).catch(error => {
      console.warn('Failed to parsing', error)
    })
  },
}
</script>

<style scoped>
</style>
