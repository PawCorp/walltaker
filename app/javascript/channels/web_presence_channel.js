import consumer from "channels/consumer"

window.webPresenceConsumer = consumer.subscriptions.create("WebPresenceChannel", {
  connected() {

  },

  disconnected() {
    this.perform('leave_link')
  },

  viewLink (linkId) {
    this.perform('view_link', {link_id: linkId})
  },

  leaveLink () {
    this.perform('leave_link')
  },

  received(data) {
  }
});
