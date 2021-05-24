$(document).on('turbolinks:load', function(){
  if ($('#content_tag_list').length > 0) {
    $('#content_tag_list').tagsinput();
  }


  if ($('.bind-content-to-token-btn').length > 0) {
    $('.bind-content-to-token-btn').on('click', function(){
      $('#content_hotspot_token_id').val($(this).data('token-id'));
      $('#content_hotspot_text').val('');
      $('#token-title-modal').text($(this).data('token-title'));
    });
  }
});
