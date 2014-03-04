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
	this.events.listen(oo.diplomka.EventType.RECEIVE_IMAGES, this.receiveImages, this);

	this.container = null;
	this.displayPanel = null;
	this.inputPanel = null;
	this.suggestTagsPanel = null;

	this.suggestedTags = [];
	this.ownTags = [];

	goog.base(this);
}
goog.inherits(oo.diplomka.Tags, goog.ui.Component);


oo.diplomka.Tags.prototype.decorate = function (element) {
	this.container = element;
	this.displayPanel = goog.dom.getElement('tags');
	this.inputPanel = goog.dom.getElement('tags-input');
	this.suggestTagsPanel = goog.dom.getElement('suggested-tags');
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

	this.getHandler().
      listen(goog.dom.getElement("suggested-tags"),
      	[goog.events.EventType.CLICK],
      	this.suggestionClick_, this);

  this.getHandler().
      listen(goog.dom.getElement("tags"),
      	[goog.events.EventType.CLICK],
      	this.removeTag_, this);
}

oo.diplomka.Tags.prototype.removeTag_ = function (event) {
	var el = event.target;
	if (goog.dom.classes.has(el, "tag-own")) {
		var txt = el.textContent;
		goog.array.remove(this.ownTags , txt);
		this.renderTags();
		this.valueChanged_();
	}
}

oo.diplomka.Tags.prototype.suggestionClick_ = function (event) {
	var el = event.target;
	if (goog.dom.classes.has(el, "tag-suggested")) {
		var txt = el.textContent;
		this.ownTags.push(txt);
		goog.dom.removeNode(el);
		this.renderTags();
		this.valueChanged_();
	}
}

oo.diplomka.Tags.prototype.handleTagShortcut = function () {
	var value = this.inputPanel.value;
	this.inputPanel.value = "";
	this.ownTags.push(value);
	this.renderTags();
	this.valueChanged_();
}

oo.diplomka.Tags.prototype.receiveImages = function (data) {
	this.suggestedTags = data["suggested_tags"];
	this.renderTagsSuggestions();
}

oo.diplomka.Tags.prototype.renderTagsSuggestions = function () {
	goog.soy.renderElement(this.suggestTagsPanel, oo.diplomka.templates.suggestedTags,
		{
			"tags": this.suggestedTags
		}
	);
}

oo.diplomka.Tags.prototype.renderTags = function () {

	goog.soy.renderElement(this.displayPanel, oo.diplomka.templates.tags,
		{
			"tags": this.ownTags
		}
	);
}


oo.diplomka.Tags.prototype.valueChanged_ = function() {
	this.events.fire(oo.diplomka.EventType.TAGS_CHANGE, this.ownTags);
}
