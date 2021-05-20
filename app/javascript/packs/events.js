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
});
