goog.provide('oo.diplomka.OptionsPane');

goog.require("oo.diplomka.Languages.Trigrams");
goog.require("oo.diplomka.Events");

/*
* @constructor
*/
oo.diplomka.OptionsPane = function(events) {
  this.languageModel_ = new oo.diplomka.Languages.Model();
  this.trigrams_ = new oo.diplomka.Languages.Trigrams(this.languageModel_);
  this.events_ = events;
  this.panel_ = document.getElementById('options-panel');
  this.events_.listen(oo.diplomka.EventType.TEXT_CHANGE, this.detectLanguage_, this);
  this.detectLanguage_("");
  this.selectedLanguage_ = null;
}

oo.diplomka.OptionsPane.prototype.detectLanguage_ = function (text) {
  this.selectedLanguage_ = this.trigrams_.detect(text);
  var params = {
    "languages": this.languageModel_.getLanguages(),
    "languageNames": this.languageModel_.getLanguageNames(),
    "wordCount": this.languageModel_.countWords(text),
    "selectedLanguage": this.selectedLanguage_
  }
  goog.soy.renderElement(this.panel_, oo.diplomka.templates.optionsPane, params);

  goog.events.listen(document.getElementById('language-select'), goog.events.EventType.CHANGE, this.languageChange_, false, this);
  this.fireChange();
}

oo.diplomka.OptionsPane.prototype.languageChange_ = function () {
  this.selectedLanguage_ = goog.dom.getElement("language-select").value;
  this.fireChange();
}

oo.diplomka.OptionsPane.prototype.fireChange = function () {
  this.events_.fire(oo.diplomka.EventType.LANGUAGE_CHANGE, this.selectedLanguage_);
}