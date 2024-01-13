import {Controller} from "@hotwired/stimulus"
import {WithModal} from '../modules/Modal.js'

export default class RangeController extends Controller {
    static targets = ['input', 'value']

    connect() {
        this.refresh()
    }

    refresh() {
        if (this.valueTarget && this.inputTarget) {
            let output = 'score > ' + this.inputTarget.value.toString();
            if (output === 'score > 0') {
                output = 'allow all'
            }
            this.valueTarget.innerText = output
        }
    }
}