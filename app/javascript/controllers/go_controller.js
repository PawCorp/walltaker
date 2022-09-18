import {Controller} from "@hotwired/stimulus"

const controls = document.createElement('a')
controls.className = 'link--anchor-shade'

export default class GoController extends Controller {
    static values = {
        to: String
    }

    connect () {
        this.element.className = 'link--anchor-shade-container'
        console.log('here', this.element)
        controls.href = this.toValue
        console.log(controls, this.element)
        this.element.prepend(controls)
        console.log('prepended', this.element)
    }
}