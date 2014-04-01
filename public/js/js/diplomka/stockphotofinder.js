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

  //this.ws.text_ = "usa obama russia";
  //this.ws.getImages();

  //var hc = new goog.ui.HoverCard(function(){window.console.log("eee");return true;});
  //hc.setElement(goog.dom.getElement('tooltip-container'));
  //hc.className = 'goog-hovercard';

  //goog.events.listen(hc, goog.ui.HoverCard.EventType.TRIGGER, onTrigger);
  //
  //SCROLL
  

  //this.splitPane.textArea.setValue("Grand Horizon has a bold sign, Teheran Tours, above its shop front on a busy commercial street. Nearby, a store sold Middle Eastern carpets, Buddha statues and paintings of Arab men.");
  //this.splitPane.tagsComponent.addTag("car");

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