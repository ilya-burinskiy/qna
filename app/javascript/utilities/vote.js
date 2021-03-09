$(document).on('turbolinks:load', () => {
  $('.vote__for, .vote__unvote, .vote__against')
  .on('ajax:success', event => {
    event.preventDefault();

    const votable_info = event.detail[0];
    const votable_id = votable_info.id;
    const votable_class = votable_info.votable;
    const votable_rating = votable_info.rating;

    $('#vote-' + votable_class + '-' + votable_id + ' .votable__rating').html(votable_rating);
  })
  .on('ajax:error', event => {
    event.preventDefault();

    const votable_info = event.detail[0];
    const votable_id = votable_info.id;
    const votable_class = votable_info.votable;
    const errors = votable_info.errors;

    $('#vote-' + votable_class + '-' + votable_id + ' .vote-errors').html(errors);
  })
});
