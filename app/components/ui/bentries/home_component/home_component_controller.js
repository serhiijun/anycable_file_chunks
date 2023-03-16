import { HomeComponentActor } from "./home_component_actor";
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    new HomeComponentActor(this.element);
    window.Birdel.subscribe({
      channel: "Ui::HomeChannel",
      id: "blah_lol"
    });
  }

  handleChange(e){
    window.Birdel.forward("ui--bentries--home-component", "home-component-actor#uploadByChunks", null, e);
  }
}
  
