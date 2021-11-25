import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ 'type', 'field' ]

  connect() {
    this.displayFields()
  }

  displayFields() {
    [...this.fieldTargets].forEach((field) => {
      let dataTypes = field.dataset.types.split(',')
      if (dataTypes.includes(this.typeTarget.value.toLowerCase())) {
        // make sure form element is hidden and disabled
        Array.from(field.getElementsByTagName('input')).forEach((input) => {
          if (!input.name.includes('action_params')) {
            return
          }
          input.disabled = false
          input.required = true
        })
        field.classList.remove('is-hidden')
      } else {
        // make sure form element is visible and active
        Array.from(field.getElementsByTagName('input')).forEach((input) => {
          if (!input.name.includes('action_params')) {
            return
          }
          input.disabled = true
          input.required = false
        })
        field.classList.add('is-hidden')
      }
    })
  }
}
