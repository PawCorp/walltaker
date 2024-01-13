import {Controller} from "@hotwired/stimulus"
import {WithModal} from '../modules/Modal.js'

class FriendshipController extends Controller {
    static targets = ['cancel']

    confirm() {
        this.modal.open()
        this.cancelTarget.focus()
    }

    cancel() {
        this.modal.close()
    }
}

export default WithModal(FriendshipController);