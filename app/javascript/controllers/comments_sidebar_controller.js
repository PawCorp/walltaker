import {Controller} from "@hotwired/stimulus"

export default class CommentsSidebarController extends Controller {
    static targets = ['toggle']
    hidden = true

    connect() {
        document.body.addEventListener('click', (e) => {
            if (!this.hidden && !this.element.contains(e.target)) {
                this.setHidden(true)
            }
        })

        document.body.addEventListener('keydown', (e) => {
            if (!this.hidden && e.key === 'Escape') {
                this.setHidden(true)
            }
        })
    }

    toggleClick(e) {
        this.setHidden(!this.hidden)
        if (e.target) {
            e.target.dataset.hidden = this.hidden
        }
    }

    setHidden(isHidden) {
        this.hidden = isHidden
        this.element.dataset.hidden = isHidden
    }
}