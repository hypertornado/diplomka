goog.provide('oo.diplomka.StockPhotoFinder');

goog.require('oo.diplomka.templates');
goog.require('oo.diplomka.SplitPane');
goog.require('oo.diplomka.websockets');

goog.require('goog.dom');
goog.require('goog.dom.ViewportSizeMonitor');
goog.require("oo.diplomka.Events");
goog.require("goog.ui.HoverCard");

/**
 * @constructor
 */
oo.diplomka.StockPhotoFinder = function() {
  this.events = new oo.diplomka.Events();
  this.generateUI();
  this.splitPane = new oo.diplomka.SplitPane(this.events);
  this.monitorResize();
  this.ws = new oo.diplomka.WebSockets(this.events);

  document.title = "Stock Photo Finder - created by Ondřej Odcházel"

  var hc = new goog.ui.HoverCard(function(){window.console.log("eee");return true;});
  hc.setElement(goog.dom.getElement('tooltip-container'));
  hc.className = 'goog-hovercard';

  goog.events.listen(hc, goog.ui.HoverCard.EventType.TRIGGER, onTrigger);


  function onTrigger(event) {
    window.console.log(event);
    hc.setPosition(goog.positioning.Corner.TOP_RIGHT);
    return true;
  }

};


oo.diplomka.StockPhotoFinder.prototype.generateUI = function() {
  var body = document.getElementsByTagName("body")[0];

  var element = goog.dom.createDom('div');

  goog.soy.renderElement(element, oo.diplomka.templates.skeleton);

  goog.dom.insertChildAt(goog.dom.getDocument().body, element, 0);
}

oo.diplomka.StockPhotoFinder.prototype.monitorResize = function () {
  var vsm = new goog.dom.ViewportSizeMonitor();
  goog.events.listen(vsm, goog.events.EventType.RESIZE, this.resizeEvent, false, this);
  this.resizeEvent();
}

oo.diplomka.StockPhotoFinder.prototype.resizeEvent = function () {
  var height = goog.dom.getViewportSize().height;
  this.splitPane.resize(height);
}