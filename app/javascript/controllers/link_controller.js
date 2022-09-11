import {Controller} from "@hotwired/stimulus"
import {WithModal} from '../modules/Modal'

class LinkController extends Controller {
    static targets = ['cancel']
    static values = {
        id: Number
    }

    consumer = null

    connect() {
        if (!this.consumer && this.idValue) {
            this.consumer = window.webPresenceConsumer
            this.consumer.viewLink(this.idValue)
        }
    }

    disconnect() {
        if (this.consumer) {
            this.consumer.leaveLink()
        }
    }

    confirm() {
        this.modal.open()
        this.cancelTarget.focus()
    }

    cancel() {
        this.modal.close()
    }
}

export default WithModal(LinkController);