
goog.provide('oo.diplomka.websockets');

goog.require("oo.diplomka.Events");
goog.require('goog.net.XhrIo');

oo.diplomka.WebSockets = function(events) {
  this.events = events;
  this.events.listen(oo.diplomka.EventType.TEXT_CHANGE, this.textChange_, this);
  this.events.listen(oo.diplomka.EventType.TAGS_CHANGE, this.tagsChange_, this);
  this.events.listen(oo.diplomka.EventType.GET_IMAGES, this.getImages, this);
  this.text_ = "";
  this.tags_ = [];

  this.requestIsProcessing = false;
  this.requestSended = null;

  this.lastRequest = null;
  this.lastRequestTime = 0;

  var self = this;

  window.setInterval(function() {self.periodCheck_();}, oo.diplomka.WebSockets.checkInterval);

}

oo.diplomka.WebSockets.checkInterval = 100;
oo.diplomka.WebSockets.waitBeforeSend = 300;

oo.diplomka.WebSockets.prototype.periodCheck_ = function() {
  if (!this.requestIsProcessing && this.lastRequest && (Date.now() - this.lastRequestTime > oo.diplomka.WebSockets.waitBeforeSend)) {
    this.getImagesRequest(this.lastRequest);
    this.lastRequest = null;
  }
}


oo.diplomka.WebSockets.prototype.getImages = function(opt_data) {

  var data;

  if (opt_data) {
    data = opt_data;
  } else {
    var data = {
      "text": this.text_,
      "tags": this.tags_,
      "from": 0,
      "size": oo.diplomka.Images.imagesRequestSize
    };
  }

  this.lastRequest = data;
  this.lastRequestTime = Date.now();
}

oo.diplomka.WebSockets.prototype.getImagesRequest = function(data) {

  //dont send same request twice
  if (this.requestSended != null && data.from == 0 && this.requestSended.text == data.text && this.requestSended.tags == data.tags){
    console.log("NO SENDING");
    return;
  }

  if (data.from == 0) {
    this.events.fire(oo.diplomka.EventType.CLEAR_IMAGES);
  }

  this.requestIsProcessing = true;
  this.requestSended = JSON.parse(JSON.stringify(data));

  var xhr = new goog.net.XhrIo();
  
  goog.events.listen(xhr, goog.net.EventType.COMPLETE, function(e, data) {
    var obj = e.target.getResponseJson();
    obj.request = this.requestSended;
    this.events.fire(oo.diplomka.EventType.RECEIVE_IMAGES, obj);
    this.requestIsProcessing = false;
  }, false, this);

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
