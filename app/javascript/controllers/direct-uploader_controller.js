import { Controller } from "stimulus"
import { DirectUpload } from "@rails/activestorage"

export default class extends Controller {

  descriptionLabel = null

  connect() {
    this.descriptionLabel = $(this.element).parent().find('small')

    // Bind to normal file selection
    this.element.addEventListener('change', (event) => {
      this.descriptionLabel.text('')
      Array.from(this.element.files).forEach(file => this.uploadFile(file))
      // you might clear the selected files from the input
      // this.element.value = null
    })
  }

  uploadFile = (file) => {
    // your form needs the file_field direct_upload: true, which
    //  provides data-direct-upload-url
    const url = this.element.dataset.directUploadUrl
    const upload = new DirectUpload(file, url, this)

    upload.create((error, blob) => {
      if (error) {
        // Handle the error
        console.log(error)
      } else {
        // Add an appropriately-named hidden input to the form with a
        //  value of blob.signed_id so that the blob ids will be
        //  transmitted in the normal upload flow
        const hiddenField = document.createElement('input')
        hiddenField.setAttribute("type", "hidden")
        hiddenField.setAttribute("value", blob.signed_id)
        hiddenField.name = this.element.name
        document.querySelector('form').appendChild(hiddenField)
      }
    })
  }

  directUploadWillStoreFileWithXHR(request) {
    request.upload.addEventListener("progress",
      event => this.directUploadDidProgress(event))
  }

  directUploadDidProgress(event) {
    // Use event.loaded and event.total to update the progress bar
    let percent = parseFloat(((event.loaded / event.total) * 100).toFixed(1))

    this.descriptionLabel.text(`${percent}%`)
    if (percent === 100) {
      this.descriptionLabel.text(`${percent}% - Upload successful`)
    }
    
  }
}
