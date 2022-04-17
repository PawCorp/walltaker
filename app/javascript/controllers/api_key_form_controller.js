import {Controller} from "@hotwired/stimulus"
import {WithModal} from '../modules/Modal'

export default class ApiKeyFormController extends Controller {
    static targets = ['key']

    connect() {
        if (this.keyTarget) {
            this.keyTarget.addEventListener('click', this.copyKey.bind(this))
        }
    }

    copyKey() {
        getSelection().selectAllChildren(this.keyTarget)
    }
}