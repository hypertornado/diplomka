

goog.provide("oo.diplomka.Events");

goog.require("oo.diplomka.EventType");
goog.require("goog.object");
goog.require("goog.array");

/*
* @constructor
*/
oo.diplomka.Events = function() {
  this.events_ = {};
}

oo.diplomka.Events.prototype.listen = function(type, callback, context) {
  var callbacks = goog.object.get(this.events_, type, []);
  var newCallback = {
    'callback': callback,
    'context': context
  };
  callbacks.push(newCallback);
  goog.object.set(this.events_, type, callbacks);
}

oo.diplomka.Events.prototype.fire = function(type, data) {
  goog.array.forEach(
    goog.object.get(this.events_, type, []),
    function (callbackItem) {
      callbackItem.callback.call(callbackItem.context, data);
    }
  );
}