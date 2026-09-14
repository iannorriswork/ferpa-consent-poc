import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["canvas", "input"]

  connect() {
    this.ctx = this.canvasTarget.getContext("2d")
    this.drawing = false
    this.setupCanvas()
  }

  setupCanvas() {
    this.ctx.strokeStyle = "#000"
    this.ctx.lineWidth = 2
    this.ctx.lineJoin = "round"
    this.ctx.lineCap = "round"
  }

  startDrawing(event) {
    this.drawing = true
    const { x, y } = this.getCoordinates(event)
    this.ctx.beginPath()
    this.ctx.moveTo(x, y)
  }

  draw(event) {
    if (!this.drawing) return
    const { x, y } = this.getCoordinates(event)
    this.ctx.lineTo(x, y)
    this.ctx.stroke()
  }

  stopDrawing() {
    if (!this.drawing) return
    this.drawing = false
    this.save()
  }

  clear() {
    this.ctx.clearRect(0, 0, this.canvasTarget.width, this.canvasTarget.height)
    this.inputTarget.value = ""
  }

  getCoordinates(event) {
    const rect = this.canvasTarget.getBoundingClientRect()
    const clientX = event.touches ? event.touches[0].clientX : event.clientX
    const clientY = event.touches ? event.touches[0].clientY : event.clientY
    return {
      x: clientX - rect.left,
      y: clientY - rect.top
    }
  }

  save() {
    const dataUrl = this.canvasTarget.toDataURL("image/png")
    this.inputTarget.value = dataUrl
  }

  // Handle form submission: convert dataUrl to Blob and attach to form
  prepareForSubmit(event) {
    if (this.inputTarget.value === "") {
      alert("Please provide a signature.")
      event.preventDefault()
      return
    }

    // Instead of sending dataUrl, we could convert it to a file
    // But for simplicity in this POC, we can also handle it in the controller if we wanted,
    // or use a hidden field and convert it to a File object here.
    
    // Converting to File object for Active Storage standard upload
    const dataUrl = this.inputTarget.value
    const blob = this.dataURLToBlob(dataUrl)
    const file = new File([blob], "signature.png", { type: "image/png" })

    // Create a new DataTransfer to add the file to a file input
    const container = new DataTransfer()
    container.items.add(file)
    
    // We need a file input target
    const fileInput = this.element.querySelector('input[type="file"]')
    fileInput.files = container.files
  }

  dataURLToBlob(dataURL) {
    const byteString = atob(dataURL.split(',')[1])
    const mimeString = dataURL.split(',')[0].split(':')[1].split(';')[0]
    const ab = new ArrayBuffer(byteString.length)
    const ia = new Uint8Array(ab)
    for (let i = 0; i < byteString.length; i++) {
      ia[i] = byteString.charCodeAt(i)
    }
    return new Blob([ab], { type: mimeString })
  }
}
