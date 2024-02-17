import {Controller} from "@hotwired/stimulus"
import {WithModal} from 'modules/modal'

class DiscordInviteController extends Controller {
    connect () {
        if (this.element) {
            this.element.addEventListener('click', this.handleClick.bind(this))
        }
    }

    handleClick (e) {
        if (!this.modal.isOpen()) this.modal.open()
    }
}

export default WithModal(DiscordInviteController)