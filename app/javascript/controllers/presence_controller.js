import {Controller} from "@hotwired/stimulus"

export default class PresenceController extends Controller {
    static values = {
        id: Number
    }

    consumer = null

    connect() {
        if (!this.consumer && this.idValue) {
            this.consumer = window.webPresenceConsumer
            setTimeout(() => this.consumer.viewLink(this.idValue), 2000)
        }
    }

    disconnect() {
        if (this.consumer) {
            this.consumer.leaveLink()
        }
    }
}
