import { ActorBase } from "../../../../javascript/birdel/actor_base";

export class HomeComponentActor extends ActorBase {
  constructor(element) {
    super(element);
  }

  uploadByChunks(e){
    // const notifyUpload = document.getElementById("notify_upload");
    // notifyUpload.insertAdjacentHTML("afterbegin", data.html)
    // const el = document.getElementById("media_input");
    const el = e.currentTarget;
    const file = el.files[0];
    console.log(file);
    const reader = new FileReader();
    const chunkSize = 1024 * 32;
    const fileChunksSize = Math.ceil(file.size / chunkSize);
    let sequenceNum = 0;
    let offset = 0;
    reader.onload = (event) => {
      const chunk = event.currentTarget.result;
      const isEnd = offset + chunkSize >= file.size;
      const byteArray = new Uint8Array(chunk);
      const arrayFrom = Array.from(byteArray);
      const req = {
        "actor": "ui__angry_cat_actor",
        "method": "upload_chunk",
        "required_component": false,
        "inputs": {
          "chunk": arrayFrom,
          "offset": offset,
          "isEnd": isEnd,
          "sequenceNum": sequenceNum,
          "fileChunksSize": fileChunksSize,
          "type": file.type
        },
        "callback": {
          "component": this.element.dataset.controller,
          "actor":     "home-component-actor",
          "method":    "updateProgress",
          "resource_id": false
        }
      }
      window.Birdel.send(req)
      offset += chunkSize;
      sequenceNum += 1;
      if (!isEnd) {
        const nextChunk = file.slice(offset, offset + chunkSize);
        reader.readAsArrayBuffer(nextChunk);
      }
    };
    const firstChunk = file.slice(offset, offset + chunkSize);
    reader.readAsArrayBuffer(firstChunk);
  }

  updateProgress(data){
    console.log(data.outputs);
  }
}
    
