<template>
  <div id="app">
    <div v-for="(book, book_id) in books" :key="book_id">
      <input v-model="book.title">
    </div>
    <button @click="addBooks">本を追加</button>
  </div>
</template>

<script>


export default {
  data() {
    return {
      books: []
    }
  },
  methods: {
    addBooks() {

    }
  }
}
</script>

<style scoped>
</style>
