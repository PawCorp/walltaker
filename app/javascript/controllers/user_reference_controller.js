import {Controller} from "@hotwired/stimulus"

export default class UserReferenceController extends Controller {
    online = false;

    connect() {
        this.refresh()
        const username = this.element.innerText
        if (username) {
            fetch(`/api/users/${username}.json`)
                .then(stream => stream.json())
                .then(result => {
                    this.online = !!result.online;
                })
                .catch(() => {
                    this.online = false
                })
                .finally(() => {
                    this.refresh()
                })
        }
    }

    refresh() {
        this.element.dataset.online = this.online.toString()
    }
}