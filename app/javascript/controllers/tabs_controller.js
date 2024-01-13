import {Controller} from "@hotwired/stimulus"
import {WithModal} from '../modules/Modal.js'

export default class TabsController extends Controller {
    static targets = ['tab', 'label']
    currentTab = 0

    connect () {
        const tabLabels = document.createElement('div');
        tabLabels.className = 'tabs__labels';

        this.tabTargets.forEach((tab, index) => {
            const tabLabel = document.createElement('button');
            tabLabel.innerText = tab.dataset.title;
            tabLabel.dataset.tabsTarget = 'label';
            tabLabel.addEventListener('click', () => this.open(index))
            tabLabels.appendChild(tabLabel);
        })

        this.scope.element.appendChild(tabLabels);

        this.tick();
    }

    open (tabIndex) {
        this.currentTab = tabIndex;
        this.tick();
    }

    tick () {
        this.tabTargets[this.currentTab].dataset.open = true;
        this.tabTargets.filter((_, index) => index !== this.currentTab).forEach(tab => tab.dataset.open = false);

        this.labelTargets[this.currentTab].dataset.open = true;
        this.labelTargets.filter((_, index) => index !== this.currentTab).forEach(tab => tab.dataset.open = false);
    }
}