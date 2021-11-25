import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    // 3 second timeout for begining the closed animation
    window.setTimeout(() => {
      this.element.classList.add("closed")
      const buttons = this.element.getElementsByTagName("button")
      Array.prototype.forEach.call(buttons, button => {
        button.classList.add("is-hidden")
      })
      // remove dom element after animation has completed
      window.setTimeout(() => this.element.parentNode.removeChild(this.element), 500)
    }, 3000)
  }

  close() {
    this.element.parentNode.removeChild(this.element)
  }
}
