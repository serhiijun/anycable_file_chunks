module Ui
  class HomeChannel < ApplicationCable::Channel
    state_attr_accessor :first_channel_stream

    def subscribed
      self.first_channel_stream = "#{params[:channel]}_#{params[:id]}"
      stream_from self.first_channel_stream
    end

    def actorDirect(data)
      actor_name = data.fetch("actor")
      inputs = data.fetch("inputs")
      callback = data.fetch("callback")
      required_component = data.fetch("required_component")
      actor_string = actor_name.split("__").map{|e| e.camelize}.join("::")
      res_name = actor_string << "::#{actor_string.split("::")[-1]}"
      actor = res_name.constantize.new()
      method = data.fetch("method")
      method_res = actor.public_send(method, inputs)
      res = {
        "ok": method_res[:ok],
        "message": method_res[:message],
        "data": {
          "actor": actor_name,
          "method": method,
          "outputs": method_res[:outputs]
        }
      }
      if required_component
        component_name = required_component.split('--').map{|i| i.gsub("-", "_").camelize}.join('::') + '::' + required_component.split('--').last.gsub("-", "_").camelize
        component = component_name.constantize.new(inputs: method_res[:outputs])
        res[:data][:html] = ApplicationController.render(component, layout: false)
      end
      if callback
        res[:callback] = callback
        res[:callback][:resourceId] = method_res[:resource_id] if method_res[:resource_id]
        ActionCable.server.broadcast(self.first_channel_stream, res)
      end
    end
  end
end