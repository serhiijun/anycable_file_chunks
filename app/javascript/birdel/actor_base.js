export class ActorBase{
  constructor(element) {
    this.element = element;
    this.name = this.element.dataset.controller;
    this.resourceId = this.element.dataset.resourceId;
    window.Birdel.addActor(this);
  }

  replace(newElHtml, oldEl){
    const parser = new DOMParser();
    const newEl = parser.parseFromString(newElHtml, "text/html").body.firstChild;
    oldEl.parentNode.replaceChild(newEl, oldEl);
  }
}