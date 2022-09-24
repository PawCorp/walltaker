import {Controller} from "@hotwired/stimulus"

function getControls () {
    const controls = document.createElement('a')
    controls.className = 'link--anchor-shade'

    return controls
}

export default class GoController extends Controller {
    static values = {
        to: String
    }

    connect () {
        if (this.element) {
            this.element.className = 'link--anchor-shade-container'
            const controls = getControls()
            controls.href = this.toValue
            this.element.prepend(controls)

            if (this.element.classList) { this.element.classList.add('clickable') }
            this.element.setAttribute('role', 'link')
            this.element.setAttribute('tabindex', '0')
            this.element.addEventListener('click', this.go.bind(this))
            this.element.addEventListener('keypress', this.go.bind(this))
        }
    }

    go(e) {
        if (this.toValue && ((e.key === 'Enter') || (e.key === ' ') || (e.key === undefined))) {
            window.location = this.toValue;
        }
    }
}