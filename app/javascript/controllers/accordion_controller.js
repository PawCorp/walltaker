import {Controller} from "@hotwired/stimulus"

export default class AccordionController extends Controller {
    static targets = ['content']
    static values = {
        expand: {
            type: Boolean,
            default: window.location.hash === '#getting-started-make-a-link'
        }
    }

    connect () {
        this.isOpen = this.expandValue;
        this.tick()
    }

    toggle () {
        this.isOpen = !this.isOpen;
        this.tick();
    }

    tick () {
        if (this.contentTarget) {
            this.contentTarget.style.display = this.isOpen ? 'block' : 'none';
            this.contentTarget.setAttribute('aria-visible', this.isOpen);
        }

        if (this.element) {
            this.element.setAttribute('aria-expanded', this.isOpen);
        }
    }
}