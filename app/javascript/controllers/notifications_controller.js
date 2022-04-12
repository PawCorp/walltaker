import {Controller} from "@hotwired/stimulus"

class NotificationsController extends Controller {
    static targets = ['trigger', 'popover']

    connect () {
        this.shown = false
        this.set()

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
    }
}

export default NotificationsController;