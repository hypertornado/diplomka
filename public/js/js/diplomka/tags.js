goog.provide('oo.diplomka.Tags');

goog.require('goog.ui.Component');
goog.require('goog.dom');
goog.require('goog.array');
goog.require('oo.diplomka.templates');

goog.require('goog.ui.KeyboardShortcutHandler');
goog.require('goog.events');
goog.require('goog.events.EventType');

/*
* @constructor
* @extends {goog.ui.Tags}
*/
oo.diplomka.Tags = function(events) {
	this.events = events;
	this.events.listen(oo.diplomka.EventType.RECEIVE_TAGS, this.receiveTags, this);

	this.container = null;
	this.displayPanel = null;
	this.inputPanel = null;

	this.suggestedTags = {
		"tags": []
	};
	this.ownTags = [];

	goog.base(this);
}
goog.inherits(oo.diplomka.Tags, goog.ui.Component);


oo.diplomka.Tags.prototype.decorate = function (element) {
	this.container = element;
	var children = goog.dom.getChildren(element);
	this.displayPanel = children[0];
	this.inputPanel = children[2];
	this.bindEvents();
}

oo.diplomka.Tags.prototype.bindEvents = function () {
	var shortcutHandler = new goog.ui.KeyboardShortcutHandler(this.inputPanel);
  	shortcutHandler.registerShortcut('save', 'enter');

  	goog.events.listen(
        shortcutHandler,
        goog.ui.KeyboardShortcutHandler.EventType.SHORTCUT_TRIGGERED, this.handleTagShortcut,
        false, this
  	);
}

oo.diplomka.Tags.prototype.handleTagShortcut = function () {
	var value = this.inputPanel.value;
	this.inputPanel.value = "";
	this.ownTags.push(value);
	this.renderTags();
}

oo.diplomka.Tags.prototype.receiveTags = function (data) {
	this.suggestedTags = data;
	this.renderTags();
}

oo.diplomka.Tags.prototype.renderTags = function () {
	goog.soy.renderElement(this.displayPanel, oo.diplomka.templates.tags,
		{
			"suggestedTags": this.suggestedTags,
			"ownTags": this.ownTags
		}
	);

	var tags = goog.array.concat(this.ownTags, this.suggestedTags.tags);

	this.events.fire(oo.diplomka.EventType.GET_IMAGES, tags);
}