
goog.provide('oo.diplomka.websockets');

goog.require("oo.diplomka.Events");
goog.require('goog.net.XhrIo');

oo.diplomka.WebSockets = function(events) {
  this.events = events;
  this.events.listen(oo.diplomka.EventType.TEXT_CHANGE, this.textChange_, this);
  this.events.listen(oo.diplomka.EventType.TAGS_CHANGE, this.tagsChange_, this);
  this.text_ = "";
  this.tags_ = [];
}


oo.diplomka.WebSockets.prototype.getImages = function() {
  var xhr = new goog.net.XhrIo();
  
  goog.events.listen(xhr, goog.net.EventType.COMPLETE, function(e, data) {
    var obj = e.target.getResponseJson();
    this.events.fire(oo.diplomka.EventType.RECEIVE_IMAGES, obj);
  }, false, this);
  
  var data = {
    "text": this.text_,
    "tags": this.tags_
  };

  xhr.send("/api/images", "POST", JSON.stringify(data), {"Content-Type": "application/json"});
}

oo.diplomka.WebSockets.prototype.textChange_ = function(text) {
  this.text_ = text;
  this.getImages();
}

oo.diplomka.WebSockets.prototype.tagsChange_ = function(tags) {
  this.tags_ = tags;
  this.getImages();
}
