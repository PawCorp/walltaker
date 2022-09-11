import {Controller} from "@hotwired/stimulus"

export default class PresenceController extends Controller {
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
}
