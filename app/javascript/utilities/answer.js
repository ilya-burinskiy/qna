$(document).on('turbolinks:load', function() {
  $('.answers-list').on('click', '.edit-answer-link', function(event) {
    event.preventDefault();
    $(this).hide();

    let answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');
  })
});
