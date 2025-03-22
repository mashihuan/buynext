import { emitter } from "@kit.BasicServicesKit";

enum EmitterEventId {
  ADD_TO_CART,
  CART_TO_ORDER
}

class EmitterUtil {
  emit(event: emitter.InnerEvent, data?: emitter.EventData | undefined) {
    emitter.emit(event, data)
  }

  on(event: emitter.InnerEvent, callback: Callback<emitter.EventData>) {
    emitter.on(event, callback)
  }

  once(event: emitter.InnerEvent, callback: Callback<emitter.EventData>) {
    emitter.once(event, callback)
  }

  off(eventId: number) {
    emitter.off(eventId)
  }
}

const emitterUtil = new EmitterUtil()

export {
  EmitterEventId,
  emitterUtil
}