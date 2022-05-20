import {Controller} from "@hotwired/stimulus"

const MEDALS = [
    { over: 50, colour: 'driftwood' },
    { over: 75, colour: 'tin' },
    { over: 150, colour: 'bronze' },
    { over: 300, colour: 'silver' },
    { over: 500, colour: 'gold' },
    { over: 800, colour: 'platinum' },
    { over: 1000, colour: 'uranium' },
    { over: 4200, colour: 'green' },
    { over: 6900, colour: 'cum' }
]

export default class UserReferenceController extends Controller {
    static values = { hideOnline: String }
    online = false;
    setCount = 0;

    connect() {
        const username = this.element.childNodes[0].textContent
        if (username) {
            fetch(`/api/users/${username}.json`)
                .then(stream => stream.json())
                .then(result => {
                    if (!this.hasHideOnlineValue) {
                        this.online = !!result.online;
                    }
                    this.setCount = result.set_count ?? 0;
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
        if (this.online) {
            this.attachCharm('online')
        } else {
            this.detachCharm('online')
        }
        this.setMedal()
    }

    attachCharm (type) {
        const charm = document.createElement('div')
        charm.className = `text-charm text-charm__${type}`

        if (type.includes('medal-')) {
            const colour = type.replace('medal-', '')
            const medal = MEDALS.find(medal => medal.colour === colour)
            if (medal) {
                charm.className = `text-charm text-charm__medal text-charm__${type}`
                charm.title = `The ${type.replace('medal-', '')} medal`
                charm.innerHTML = `
                    <ion-icon
                        aria-label="The ${type.replace('medal-', '')} medal"
                        title="The ${type.replace('medal-', '')} medal"
                        name="trophy-sharp">
                    </ion-icon>
                    <small>${medal.over}</small>
                `
            }
        }

        this.element.appendChild(charm)
    }

    detachCharm (type) {
        const charms = this.element.querySelectorAll(`.text-charm__${type}`)
        if (charms) charms.forEach(charm => charm.remove())
    }

    setMedal () {
        const currentMedal = MEDALS.reduce((acc, i) => {
            if (this.setCount >= i.over) acc = i
            return acc
        }, null)
        MEDALS.forEach((medalType) => {
            this.detachCharm(`medal-${medalType.colour}`)
        })
        if (currentMedal) this.attachCharm(`medal-${currentMedal.colour}`)
    }
}