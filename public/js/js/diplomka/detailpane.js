goog.provide('oo.diplomka.DetailPane');

goog.require("oo.diplomka.Events");
goog.require('goog.dom.classes');
goog.require('goog.net.XhrIo');

oo.diplomka.DetailPane = function(events) {
  this.events_ = events;
  this.container_ = document.getElementById("img-detail");


  this.events_.listen(oo.diplomka.EventType.SHOW_IMG_DETAIL, this.render_, this);
}

oo.diplomka.DetailPane.prototype.render_ = function(id) {

  goog.soy.renderElement(this.container_, oo.diplomka.templates.imageDetails, {"id": id});
  goog.dom.classes.remove(this.container_, "hide");

  var xhr = new goog.net.XhrIo();
  
  goog.events.listen(xhr, goog.net.EventType.COMPLETE, function(e) {
    var obj = e.target.getResponseJson();

    goog.soy.renderElement(document.getElementById("img-info"), oo.diplomka.templates.imageDetailsMetadata, {"data": obj});
    goog.soy.renderElement(document.getElementById("img-similar"), oo.diplomka.templates.suggestedImages, {"data": obj['suggestions']});

    goog.array.forEach(document.getElementsByClassName("suggested-image"), function(el){
      goog.events.listen(el, goog.events.EventType.CLICK, this.changeImgEvent_, false, this);
    }, this);

    goog.events.listen(document.getElementById("close-img-window"), goog.events.EventType.CLICK, this.close_, false, this);

  }, false, this);
  xhr.send("/api/detail/" + id, "GET");

}

oo.diplomka.DetailPane.prototype.changeImgEvent_ = function(e) {
  var id = e.target.getAttribute("data-id");
  this.render_(id);
}

oo.diplomka.DetailPane.prototype.close_ = function() {
  goog.dom.classes.add(this.container_, "hide");
}

