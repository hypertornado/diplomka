
goog.provide('oo.diplomka.Images');

goog.require('goog.ui.Component');
goog.require('oo.diplomka.templates');
goog.require('goog.array');

/*
* @constructor
* @extends {goog.ui.Images}
*/
oo.diplomka.Images = function(events) {
	this.events = events;
	this.events.listen(oo.diplomka.EventType.RECEIVE_IMAGES, this.renderImages, this);
  this.events.listen(oo.diplomka.EventType.CLEAR_IMAGES, this.clearImages, this);

  this.imagesDiv_ = goog.dom.getElement("images");
  this.hitsContainer_ = goog.dom.getElement("hits-container");

  this.lastData = null;

  /*this.getHandler().
      listen(goog.dom.getElement("load-more"),
        [goog.events.EventType.CLICK],
        this.loadMore_, false, this);
  */


  this.getHandler().listen(goog.dom.getElement("split-second"), goog.events.EventType.SCROLL, this.scrollEvent_, false, this);

	goog.base(this);
}
goog.inherits(oo.diplomka.Images, goog.ui.Component);

oo.diplomka.Images.imagesRequestSize = 20;

oo.diplomka.Images.prototype.renderImages = function (data) {
	window.console.log(data);
	if (data.images.hits) {
    if (data.request.from > 0) {
      this.renderImagesAppend_(data);
    } else {
      this.renderImagesFirst_(data);
    }
    this.lastData = data;
	}
}

oo.diplomka.Images.prototype.renderImagesFirst_ = function(data) {
  this.hitsContainer_.textContent = data.images.hits.total + " hits";
  this.imagesDiv_.innerHTML = "";
  this.renderImagesAppend_(data);
}

oo.diplomka.Images.prototype.renderImagesAppend_ = function(data) {
  var images = this.imagesElements(data);
  for (var i = 0; i < images.length; ++i) {
    var image = images[i];
    goog.dom.appendChild(this.imagesDiv_, image);
  }

}

oo.diplomka.Images.prototype.imagesElements = function(data) {
  var el = goog.dom.createDom("div");
  goog.soy.renderElement(el, oo.diplomka.templates.images,{"images": data.images});
  return goog.array.clone(goog.dom.getChildren(el));
}

oo.diplomka.Images.prototype.clearImages = function () {
  this.imagesDiv_.innerHTML = "";
  this.hitsContainer_.innerHTML = "";
  this.lastData = null;
}

oo.diplomka.Images.prototype.scrollEvent_ = function () {
  var images = this.imagesDiv_.children;
  if (images.length == 0) return;
  var image = images[images.length - 1];
  var offset = image.offsetTop;
  console.log("SCROLL", offset);

  var loadingAreaHeight = 100;

  var scrollEl = goog.dom.getElement("split-second");
  if (scrollEl.scrollHeight - scrollEl.scrollTop - scrollEl.offsetHeight < loadingAreaHeight) {
    this.loadMore_();
  }

  //scrollHeight
  //scrollTop
  //clientHeight
  //offsetHeight

}

oo.diplomka.Images.prototype.loadMore_ = function () {
  var request = goog.object.clone(this.lastData.request);

  request.from = this.imagesDiv_.children.length;
  this.events.fire(oo.diplomka.EventType.GET_IMAGES, request);
}
