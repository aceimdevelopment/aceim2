(function() {
  var HOST = "https://sfo2.digitaloceanspaces.com/"

  addEventListener("trix-file-accept", function(event) {

    const maxFileSize = 1024 * 1024 // 1MB 
    if (event.file.size > maxFileSize) {
      event.preventDefault()
      alert("Tamaño máximo permitido de 1MB")
    }
  })
  document.addEventListener("trix-attachment-remove", this.trixRemoveAttachmentEvent)

  trixRemoveAttachmentEvent = (event) => {
    const attributes = event.attachment.getAttributes();
    // attachment_id is from ActiveStorage::Attachment in the Rails backend to keep track of attachments
    this.setState({ deleteList: [...this.state.deleteList, attributes.attachment_id] })
  }



  addEventListener("trix-attachment-add", function(event) {
    if (event.attachment.file) {
      uploadFileAttachment(event.attachment)
    }
  })

  function uploadFileAttachment(attachment) {
    uploadFile(attachment.file, setProgress, setAttributes)

    function setProgress(progress) {
      attachment.setUploadProgress(progress)
    }

    function setAttributes(attributes) {
      attachment.setAttributes(attributes)
    }
  }

  function uploadFile(file, progressCallback, successCallback) {
    var key = createStorageKey(file)
    var formData = createFormData(key, file)
    var xhr = new XMLHttpRequest()

    xhr.open("POST", HOST, true)

    xhr.upload.addEventListener("progress", function(event) {
      var progress = event.loaded / event.total * 100
      progressCallback(progress)
    })

    xhr.addEventListener("load", function(event) {
      if (xhr.status == 204) {
        var attributes = {
          url: HOST + key,
          href: HOST + key + "?content-disposition=attachment"
        }
        successCallback(attributes)
      }
    })

    xhr.send(formData)
  }

  function createStorageKey(file) {
    var date = new Date()
    var day = date.toISOString().slice(0,10)
    var name = date.getTime() + "-" + file.name
    return [ "tmp", day, name ].join("/")
  }

  function createFormData(key, file) {
    var data = new FormData()
    data.append("key", key)
    data.append("Content-Type", file.type)
    data.append("file", file)
    return data
  }
})();
