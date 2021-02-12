$(document).on('turbolinks:load', function() {
  $('.question').on('click', '.edit-question-link', function(event) {
    event.preventDefault();
    $(this).hide();

    let questionId = $(this).data('questionId');
    $('form#edit-question-' + questionId).removeClass('hidden');
  })
});
