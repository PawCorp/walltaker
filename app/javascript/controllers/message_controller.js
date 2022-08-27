import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static values = {
        from: String
    }

    connect() {
        const current_username_el = document.querySelector('.user-tools > .username')
        if (current_username_el) {
            const current_username = current_username_el.innerText
            const is_self = this.fromValue === current_username

            if (is_self && this?.context?.scope?.element) {
                this.context.scope.element.classList.add('messages__message_container--self')
            }
        }
    }
}
