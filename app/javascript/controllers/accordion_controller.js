import {Controller} from "@hotwired/stimulus"

export default class AccordionController extends Controller {
    static targets = ['content']
    isOpen = window.location.hash === '#getting-started-make-a-link'

    connect () {
        this.tick()
    }

    toggle () {
        this.isOpen = !this.isOpen;
        this.tick();
    }

    tick () {
        if (this.contentTarget) {
            this.contentTarget.style.display = this.isOpen ? 'block' : 'none';
            this.contentTarget.ariaExpanded = this.isOpen
        }
    }
}