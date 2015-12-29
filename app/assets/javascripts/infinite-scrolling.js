$(document).ready(function() {
  if ($('.pagination').length) {
    $(window).scroll(function() {
      var url = $('a[rel="next"]').attr('href');
      if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 50) {
        $('nav.pagination').text("Please Wait...");
        return $.getScript(url);
      }
    });
    return $(window).scroll();
  }
});
