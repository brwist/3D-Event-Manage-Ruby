import { Controller } from "stimulus"

export default class extends Controller {

  connect() {
    if (this.isEventContentSelect) {
      $(this.element).select2({
        ajax: {
          url: '/contents.json',
          dataType: 'json',
          data: function (params) {
            var query = {
              'q[name_cont]': params.term,
              type: 'images'
            }
            return query;
          },
          processResults: function (data) {
            let formatedData = $.map(data, function (obj) {
              obj.id = obj.file_blob.key;
              obj.text = obj.name;
            
              return obj;
            });

            return {
              results: formatedData
            };
          }
        }
      })
    } else {
      $(this.element).select2()
    }
  }

  disconnect() {
    $(this.element).select2("destroy")
  }

  get isEventContentSelect() {
    return this.element.dataset.type && this.element.dataset.type === 'event-content-select';
  }

}
