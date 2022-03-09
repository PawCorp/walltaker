import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ['switch', 'input', 'container']

    connect() {
        this.shown = this.switchTarget.checked || this.inputTarget.value !== ''
        this.set()
    }

    toggle () {
        this.shown = !this.shown
        this.set()
    }

    set () {
        if (!this.shown) this.inputTarget.value = ''
        this.switchTarget.checked = this.shown
        this.containerTarget.style.display = this.shown ? 'block' : 'none'
    }
}
