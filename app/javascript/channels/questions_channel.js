import consumer from "./consumer"

consumer.subscriptions.create('QuestionsChannel', {
  connected() {
    console.log('Connected')
    this.perform('follow')
  },

  received(data) {
    $('.questions-list').append(data)
  }
})
