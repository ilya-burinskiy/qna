import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  const questionId = $('.question').data('id');

  consumer.subscriptions.create({ channel: 'CommentsChannel', question_id: questionId }, {
    connected() {
      this.perform('follow');
    },

    received(data) {
      let commentsList;
      switch (data.commentable_type) {
        case 'Question':
          commentsList = $('#question-' + data.commentable_id + ' .question-comments');
          break;

        case 'Answer':
          commentsList = $('#answers-list__' + data.commentable_id + ' .answer-comments');
          break;

        default:
          break;
      }

      commentsList.append(`
        <li id="comment-${data.id}" class="comment">
          <p class="comment__body">${data.body}</p>
        </li>
      `);
    }
  })
})
