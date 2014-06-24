

goog.provide('oo.diplomka.SplitPane');

goog.require('goog.ui.SplitPane');
goog.require('oo.diplomka.Textarea');
goog.require('oo.diplomka.Images');
goog.require('oo.diplomka.Tags');

/*
* @constructor
* @extends {goog.ui.SplitPane}
*/
oo.diplomka.SplitPane = function(events) {
  this.events = events;



  this.textArea = new oo.diplomka.Textarea(events);
  this.imagesComponent = new oo.diplomka.Images(events);
  this.tagsComponent = new oo.diplomka.Tags(events);

  goog.base(
    this,
    new goog.ui.Component(),
    new goog.ui.Component(),
    goog.ui.SplitPane.Orientation.HORIZONTAL
  );

  this.setInitialSize(300);

  this.container = document.getElementById('split-container');
  this.decorate(this.container);

  this.textArea.decorate(document.getElementById('text-input'));
  this.imagesComponent.decorate(document.getElementById('images-container'));
  this.tagsComponent.decorate(document.getElementById('tags-container'));
  //this.textArea.setValue("");

  this.setFirstComponentSize();
  this.textArea.getElement().focus();
}
goog.inherits(oo.diplomka.SplitPane, goog.ui.SplitPane);

oo.diplomka.SplitPane.prototype.resize = function(height) {
  goog.style.setHeight(this.container, height);
  goog.style.setHeight(document.getElementById('split-first'), height);
  goog.style.setHeight(document.getElementById('split-handle'), height);
  goog.style.setHeight(document.getElementById('split-second'), height);
}