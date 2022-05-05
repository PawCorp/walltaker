import {Controller} from "@hotwired/stimulus"

export default class NewCommentFormController extends Controller {
    static targets = ['send', 'input']

    connect() {
        this.element.addEventListener('submit', this.focusInput.bind(this))
    }

    focusInput() {
        if (this.sendTarget && this.inputTarget) {
            this.sendTarget.blur()
            setTimeout(() => this.inputTarget.focus(), 0)
        }
    }

    inputChange(e) {
        if (e.target) {
            const valid = e.target.value.length > 0
            this.setDisabled(!valid)
        }
    }

    setDisabled(isDisabled) {
        if (this.sendTarget) {
            this.sendTarget.disabled = isDisabled
        }
    }
}