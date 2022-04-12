import {Controller} from "@hotwired/stimulus"

class NotificationsController extends Controller {
    static targets = ['trigger', 'popover']

    connect () {
        document.body.addEventListener('click', (e) => {
            if (!this.popoverTarget.contains(e.target) && !this.triggerTarget.contains(e.target)) {
                this.close()
            }
        })

        document.body.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') {
                this.close()
            }
        })

        this.shown = false
        this.hasNotifs = this.popoverTarget.querySelectorAll('.notification').length > 0
        this.set()
    }

    close () {
        this.shown = false
        this.set()
    }

    toggle () {
        this.shown = !this.shown
        this.set()
    }

    set () {
        this.popoverTarget.dataset.open = this.shown
        this.triggerTarget.dataset.hasNotifs = this.hasNotifs
    }
}

export default NotificationsController;