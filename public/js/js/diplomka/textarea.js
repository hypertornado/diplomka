
goog.provide('oo.diplomka.Textarea');

goog.require('goog.ui.Component');

/*
* @constructor
* @extends {goog.ui.Textarea}
*/
oo.diplomka.Textarea = function(events) {
	this.events = events;
	goog.base(this);
}

goog.inherits(oo.diplomka.Textarea, goog.ui.Component);

oo.diplomka.Textarea.prototype.setValue = function(value) {
	this.getElement().value = value;
}

oo.diplomka.Textarea.prototype.getValue = function() {
	return this.getElement().value;
}

oo.diplomka.Textarea.prototype.enterDocument = function(value) {
	this.getHandler().
      listen(this.getElement(),
      	[goog.events.EventType.KEYUP, goog.events.EventType.PASTE, goog.events.EventType.CUT],
      	this.valueChanged_);

	this.getElement().focus();
}

oo.diplomka.Textarea.prototype.valueChanged_ = function() {
	this.events.fire(oo.diplomka.EventType.TEXT_CHANGE, this.getValue());
}