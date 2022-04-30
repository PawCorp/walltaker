import {Controller} from "@hotwired/stimulus"

export default class CommentsSidebarController extends Controller {
    static targets = ['toggle', 'badge', 'comment']
    hidden = true
    unseen = 0
    past_first_load = false

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
        setTimeout(() => this.past_first_load = true, 500)
    }

    commentTargetConnected(comment) {
        if (this.past_first_load && this.hidden && this.badgeTarget) {
            this.setUnseen(this.unseen + 1)
        }
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
        if (!this.hidden) {
            this.setUnseen(0)
        }
    }

    setUnseen(count) {
        this.unseen = count
        const badge = this.unseen > 9 ? '+' : this.unseen
        if (this.badgeTarget) {
            this.badgeTarget.innerText = this.unseen ? badge : ''
            this.badgeTarget.dataset.hidden = !this.unseen
        }
    }
}