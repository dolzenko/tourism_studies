$(function() {
  $(".articles.index .item").hover(function() {
    $(this).find(".controls:first").toggle();
  });
});
