import {Controller} from "@hotwired/stimulus"

const controls = document.createElement('a')
controls.className = 'link--anchor-shade'

export default class GoController extends Controller {
    static values = {
        to: String
    }

    connect () {
        this.element.className = 'link--anchor-shade-container'
        controls.href = this.toValue
        this.element.prepend(controls)
    }
}