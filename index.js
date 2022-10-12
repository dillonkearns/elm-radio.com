/** @typedef {{load: (Promise<unknown>); flags: (unknown)}} ElmPagesInit */

/** @type ElmPagesInit */

import Plyr from "https://cdn.skypack.dev/plyr";

customElements.define(
  "plyr-audio",
  class extends HTMLElement {
    constructor() {
      super();
      this._seconds = null;
      this._src = null;
    }

    get seconds() {
      return this._seconds;
    }

    set seconds(value) {
      let parsed;
      try {
        parsed = parseFloat(value);
      } catch (e) {
        return;
      }
      if (parsed) {
        console.log("Seek to", parseFloat(value));
        this.player.currentTime = parseFloat(value);
        if (!this.player.playing) {
          this.player.play();
        }
      } else {
      }
    }

    set src(value) {
      if (this._src === value) return;
      this._src = value;
    }

    attributeChangedCallback(name, oldValue, newValue) {}
    static get observedAttributes() {
      return ["seconds"];
    }

    connectedCallback() {
      var s = document.createElement("audio");
      s.setAttribute("src", this._src);
      s.setAttribute("id", "player");
      this.appendChild(s);
      this.player = new Plyr("#player");
    }
  }
);

export default {
  load: async function (elmLoaded) {
    const app = await elmLoaded;
  },
  flags: function () {
    return "You can decode this in Shared.elm using Json.Decode.string!";
  },
};
