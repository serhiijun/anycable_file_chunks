// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import { ActorBirdel } from "../birdel/actor_birdel"

if (window.Birdel) {
  delete window.Birdel;
}
window.Birdel = new ActorBirdel();


const application = Application.start()
application.debug = false
window.Stimulus   = application

export { application }