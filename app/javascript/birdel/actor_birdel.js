import { createConsumer } from "@rails/actioncable";

export class ActorBirdel {
  constructor() {
    this.actors = {};
  }

  addActor(actor) {
    if(!this.actors[actor.constructor.name]) this.actors[actor.constructor.name] = [];
    this.actors[actor.constructor.name].push(actor);
  }

  getActor(componentCssClass, actorName, resourceId){
    const actorDashed = actorName;
    const actorCamelized = actorDashed.split('-').map(word => {return word.toUpperCase()[0] + word.slice(1)}).join("");
    return resourceId
      ? this.actors[actorCamelized].find(actor => actor.name === componentCssClass && actor.resourceId === resourceId)
      : this.actors[actorCamelized].find(actor => actor.name === componentCssClass);
  }

  forward(componentCssClass, actorAndMethod, resourceId, e){
    const parts = actorAndMethod.split('#');
    const actorDashed = parts[0];
    const methodName = parts[1];
    const actorCamelized = actorDashed.split('-').map(word => {return word.toUpperCase()[0] + word.slice(1)}).join("");
    const actor = resourceId
      ? this.actors[actorCamelized].find(actor => actor.name === componentCssClass && actor.resourceId === resourceId)
      : this.actors[actorCamelized].find(actor => actor.name === componentCssClass);
    return actor[methodName].call(actor, e);
  }

  subscribe({channel, id} = {}) {
    const consumer = createConsumer();
    this.channel = consumer.subscriptions.create(
      {
        channel: channel,
        id: id
      },
      {
        connected: () => console.log("connected"),
        received: (res) => {
          console.log("_actor_response_", res);
          const callback = res.callback;
          const componentCssClass = callback.component;
          const actorName = callback.actor.split('--').pop().split('-').map(word => {return word.toUpperCase()[0] + word.slice(1)}).join("");
          if (callback.resourceId){
            const actor = this.actors[actorName].find(actor => actor.name == componentCssClass && actor.resourceId == callback.resourceId);
            actor[callback.method].call(actor, res.data);
          } else {
            const actor = this.actors[actorName].find(actor => actor.name == componentCssClass);
            actor[callback.method].call(actor, res.data);
          }
        },
        disconnected: () => console.log("disconnected")
      }
    );
  }

  send(birdelRequest) {
    this.channel.perform("actorDirect", birdelRequest);
  }
}