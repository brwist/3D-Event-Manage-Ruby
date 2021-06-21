import { Controller } from "stimulus"

export default class extends Controller {

  connect() {
    if (this.isEventContentSelect) {
      this.initContentSelect()
    } else if (this.isHotspotEventContentSelect) {
      this.initContentSelect(true)
    } else {
      $(this.element).select2()
    }
  }

  disconnect() {
    $(this.element).select2("destroy")
  }

  initContentSelect(hotspotAttachSelect = false) {
    let options = {
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
            newObj.text = obj.name;
            if (hotspotAttachSelect) {
              newObj.id = obj.id;
            } else {
              newObj.id = obj.file_blob.key;
            }
          
            return newObj;
          });

          return {
            results: formatedData
          };
        }
      }
    }

    if (hotspotAttachSelect) {
      // Select2 does not function properly when I use it inside a Bootstrap modal
      // https://select2.org/troubleshooting/common-problems
      options.dropdownParent = $('#bindContentModal')
    }

    $(this.element).select2(options)
  }

  get isEventContentSelect() {
    return this.element.dataset.type && this.element.dataset.type === 'event-content-select';
  }

  get isHotspotEventContentSelect() {
    return this.element.dataset.type && this.element.dataset.type === 'event-hotspot-content-select';
  }

}
