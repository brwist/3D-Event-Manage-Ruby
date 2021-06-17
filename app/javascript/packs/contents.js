$(document).on('turbolinks:load', function(){
  if ($('#content_tag_list').length > 0) {
    $('#content_tag_list').tagsinput();
  }

  // Search control
  if ($('#content-query').length > 0) {
    let $output = $('#output');

    $('#content-query').change(function(){
      let $this = $(this);

      $.ajax({
        url: '/contents/search',
        type: 'GET',
        data: {
          snippet: $this.val()
        },
        success: function(data) {
          $output.html('');

          for (item of data) {
            let $newItem = $("<li></li>");
            $newItem.text(item.name);

            $output.append($newItem);
          }
        }
      });
    });
  }
});
