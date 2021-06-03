$(document).on('turbolinks:load', function(){
  if ($('.navigation-selectbox').length > 0) {
    $('.navigation-selectbox').change(function(){
      let $this = $(this);

      $.ajax({
        url: '/hotspots',
        type: 'POST',
        data: {
          hotspot: {
            token_id: $this.data('token'),
            type: 'navigation',
            event_id: $this.data('event'),
            room_id: $this.val()
          }
        }
      });
    });
  }
});
