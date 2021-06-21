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
              let newObj = {};
              newObj.id = obj.file_blob.key;
              newObj.text = obj.name;
            
              return newObj;
            });

            return {
              results: formatedData
            };
          }
        }
      })
    } else if (this.isHotspotEventContentSelect) {
      $(this.element).select2({
        dropdownParent: $('#bindContentModal'), // https://select2.org/troubleshooting/common-problems
        ajax: {
          url: '/contents.json',
          dataType: 'json',
          data: function (params) {
            var query = {
              'q[name_cont]': params.term,
            }
            return query;
          },
          processResults: function (data) {
            let formatedData = $.map(data, function (obj) {
              let newObj = {};
              newObj.id = obj.id;
              newObj.text = obj.name;
            
              return newObj;
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

  get isHotspotEventContentSelect() {
    return this.element.dataset.type && this.element.dataset.type === 'event-hotspot-content-select';
  }

}
