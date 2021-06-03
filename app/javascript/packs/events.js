$(document).on('turbolinks:load', function(){

  // Upload attendees logic
  if ($("#upload-attendees-select").length > 0) {
    $("#upload-attendees-select").change(function(e){
      let $this = $(this);
      let $label = $('#upload-attendees-label');
      let $button = $('#upload-attendees-btn');

      if ($this.val() === '') {
        // Disable upload
        $label.text('Choose file');
        $button.prop('disabled', true);
        $button.addClass('btn-light');
        $button.removeClass('btn-info');

      } else {
        // Enable upload
        $label.text(e.target.files[0].name);
        $button.prop('disabled', false);
        $button.addClass('btn-info');
        $button.removeClass('btn-light');
      }

    });
  }

  // Modal windows for attaching stuff to tokens
  if ($('.bind-content-to-token-btn').length > 0) {
    $('.bind-content-to-token-btn').on('click', function(){
      $('#content_hotspot_token_id').val($(this).data('token-id'));
      $('#content_hotspot_text').val('');
      $('#token-title-content-modal').text($(this).data('token-title'));
    });
  }

  if ($('.bind-url-to-token-btn').length > 0) {
    $('.bind-url-to-token-btn').on('click', function(){
      $('#url_hotspot_token_id').val($(this).data('token-id'));
      $('#url_hotspot_text').val('');
      $('#url_hotspot_url').val('');
      $('#token-title-url-modal').text($(this).data('token-title'));
    });
  }

  // Tag list
  if ($('#event_tag_list').length > 0) {
    $('#event_tag_list').tagsinput();
  }
});
