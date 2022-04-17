import {Controller} from "@hotwired/stimulus"
import {WithModal} from '../modules/Modal'

class FriendshipController extends Controller {
    static targets = ['cancel', 'username']
    online = false;

    connect() {
        this.refresh()
        const username = this.usernameTarget.innerText
        if (username) {
            fetch(`/api/users/${username}.json`)
                .then(stream => stream.json())
                .then(result => {
                    this.online = !!result.online;
                })
                .catch(() => {
                    this.online = false
                })
                .finally(() => {
                    this.refresh()
                })
        }
    }

    confirm() {
        this.modal.open()
        this.cancelTarget.focus()
    }

    cancel() {
        this.modal.close()
    }

    refresh() {
        this.usernameTarget.dataset.online = this.online.toString()
    }
}

export default WithModal(FriendshipController);