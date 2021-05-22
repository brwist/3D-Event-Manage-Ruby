$(document).on('turbolinks:load', function(){
  if ($('#content_tag_list').length > 0) {
    $('#content_tag_list').tagsinput();
  }
});
