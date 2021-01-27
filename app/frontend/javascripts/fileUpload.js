import 'uppy/dist/uppy.min.css'
import ja_JP from '@uppy/locales/lib/ja_JP'
import {
  Core,
  FileInput,
  Informer,
  ProgressBar,
  ThumbnailGenerator,
  AwsS3,
  Dashboard,
  XHRUpload
} from 'uppy'

var file_num = 0

function fileUpload(fileInput) {
  const imagePreview = document.querySelector('.upload-preview img'),
    formGroup = fileInput.parentNode
  formGroup.removeChild(fileInput)

  const uppy = Core({
    autoProceed: true,
    allowMultipleUploads: true,
    locale: ja_JP,
  })
  .use(Dashboard, {
    target: formGroup,
    inline: true,
    height: 300,
    width: 500,
    showProgressDetails: true,
    replaceTargetContent: true,
  })
  uppy.use(XHRUpload, {
    endpoint: '/upload', // Shrine's upload endpoint
  })

  uppy.on('upload-success', (file, response) => {
    const hiddenField = document.createElement('input')
    hiddenField.type = 'hidden'
    hiddenField.name = `post[photos_attributes][${file_num}][image]`
    hiddenField.value = uploadedFileData(file, response, fileInput)

    document.querySelector('form').appendChild(hiddenField)
    //hiddenInput.value = JSON.stringify(response.body)
    file_num += 1
  })
}

const uploadedFileData = (file, response, fileInput) => {
  return JSON.stringify(response.body)
}

export default fileUpload
