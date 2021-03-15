import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  const questionId = $('.question').data('id');
  consumer.subscriptions.create({ channel: 'AnswersChannel', question_id: questionId }, {
    connected() {
      this.perform('follow');
    },

    received(data) {
      if (gon.user_id != data.author_id) {
        $('.answers-list').append(`
          <li id="answers-list__${data.id}">
            <p>${data.body}</p>
            <ul class="answer-comments"></div>
          </li>
        `)
      }
    }
  })
})
