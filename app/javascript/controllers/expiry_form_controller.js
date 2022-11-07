import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ['switch', 'input']

    connect() {
        this.enabled = !this.switchTarget.checked
        this.set()
    }

    toggle () {
        this.enabled = !this.enabled
        this.set()
    }

    set () {
        if (!this.enabled) this.inputTarget.value = ''
        this.switchTarget.checked = !this.enabled
        this.inputTarget.style.display = !this.enabled ? 'none' : 'flex';
    }
}
