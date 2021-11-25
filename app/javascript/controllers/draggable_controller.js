import { Controller } from "stimulus"
import { Sortable } from '@shopify/draggable'

export default class extends Controller {
  static targets = [ 'actions', 'item' ]

  connect() {
    let draggable = new Sortable(this.actionsTarget, {
      mirror: {
        appendTo: '.draggable-target',
        constrainDimensions: true,
      },
    })
    draggable.on('drag:stop', (e) => {
      let source = e.data.source
      let actionId = source.getAttribute('data-action-id')
      let children = Array.prototype.slice.call(this.actionsTarget.children)
      let filteredChildren = children.filter(child => child.classList.length == 1 || child.classList.contains('draggable-source--is-dragging'))
      let index = filteredChildren.indexOf(source)
      // update order of actionId to 1 plus the index
      fetch(`/actions/${actionId}/reorder`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': this.getMetaValue('csrf-token')
        },
        body: JSON.stringify({ order: (index + 1) })
      }).then(() => window.location.reload())
    })
  }

  getMetaValue(name) {
    const element = document.head.querySelector(`meta[name="${name}"]`)
    return element.getAttribute("content")
  }
}
