
goog.provide('oo.diplomka.Images');

goog.require('goog.ui.Component');
goog.require('oo.diplomka.templates');

/*
* @constructor
* @extends {goog.ui.Images}
*/
oo.diplomka.Images = function(events) {
	this.events = events;
	this.events.listen(oo.diplomka.EventType.RECEIVE_IMAGES, this.renderImages, this);
	goog.base(this);
}
goog.inherits(oo.diplomka.Images, goog.ui.Component);

oo.diplomka.Images.prototype.renderImages = function (data) {
	window.console.log(data);

	//console.log(this.getElement());

	if (data.response.hits) {
		goog.soy.renderElement(this.getElement(), oo.diplomka.templates.images,{"images": data});
	}
}
