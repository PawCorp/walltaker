import {Controller} from "@hotwired/stimulus"
import {WithModal} from '../modules/Modal'

class PornSearchController extends Controller {
    static targets = ['thumbnail']
    static values = {
        secondsSinceLastWallpaper: Number
    }

    connect () {
        this.timer = setInterval(() => {
            this.secondsSinceLastWallpaperValue++
        }, 1000)
    }

    disconnect () {
        clearInterval(this.timer)
    }

    click_thumbnail (e) {
        if (this.secondsSinceLastWallpaperValue && this.secondsSinceLastWallpaperValue < 60) {
            e.preventDefault()
            e.stopPropagation()
            this.modal.open()
            this.thumbnailToConfirm = e.target
        }
    }

    cancel () {
        this.modal.close()
    }

    confirm () {
        if (this.thumbnailToConfirm) {
            const button = this.thumbnailToConfirm.closest('button')
            const form = this.thumbnailToConfirm.closest('form')
            if (button) form.requestSubmit(button)
        }
        this.modal.close()
    }
}

export default WithModal(PornSearchController);