import {Controller} from "@hotwired/stimulus"
import {WithModal} from 'modules/Modal.js'

function copy(str) {
    if (navigator?.clipboard?.writeText) {
        navigator.clipboard.writeText(str)
    } else {
        const el = document.createElement('textarea');
        el.value = str;
        el.setAttribute('readonly', '');
        el.style.position = 'absolute';
        el.style.left = '-9999px';
        document.body.appendChild(el);
        el.select();
        document.execCommand('copy');
        document.body.removeChild(el);
    }
};

class LinkController extends Controller {
    static targets = ['cancel', 'copy', 'shareIcon', 'checkmarkIcon']
    static values = {
        id: String
    }

    connect() {
        if (this.copyTarget) {
            this.copyTarget.addEventListener('click', this.copyLink.bind(this))
        }

        if (this.checkmarkIconTarget) {
            this.checkmarkIconTarget.style.display = 'none'
        }
    }

    disconnect() {
        if (this.copyTarget) {
            this.copyTarget.removeEventListener('click', this.copyLink.bind(this))
        }
    }

    copyLink(e) {
        e.preventDefault()
        try {
            copy(`https://walltaker.joi.how/links/${this.idValue}`)
            if (this.checkmarkIconTarget) {
                this.checkmarkIconTarget.style.display = 'inline-block'
            }
            if (this.shareIconTarget) {
                this.shareIconTarget.style.display = 'none'
            }
            if (this.copyTarget) {
                this.copyTarget.innerText = 'Copied!'
            }
        } catch (e) {
            console.warn(e)
            if (this.checkmarkIconTarget) {
                this.checkmarkIconTarget.style.display = 'none'
            }
            if (this.shareIconTarget) {
                this.shareIconTarget.style.display = 'inline-block'
            }
            if (this.copyTarget) {
                this.copyTarget.innerText = 'Not supported :('
            }
        }
    }

    confirm() {
        this.modal.open()
        this.cancelTarget.focus()
    }

    cancel() {
        this.modal.close()
    }
}

export default WithModal(LinkController);