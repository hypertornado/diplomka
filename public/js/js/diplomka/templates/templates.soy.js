// This file was automatically generated from templates.soy.
// Please don't edit this file by hand.

goog.provide('oo.diplomka.templates');

goog.require('soy');
goog.require('soydata');


/**
 * @param {Object.<string, *>=} opt_data
 * @param {(null|undefined)=} opt_ignored
 * @return {string}
 * @notypecheck
 */
oo.diplomka.templates.helloWorld = function(opt_data, opt_ignored) {
  return '<span>' + soy.$$escapeHtml(opt_data.message) + '</span>';
};


/**
 * @param {Object.<string, *>=} opt_data
 * @param {(null|undefined)=} opt_ignored
 * @return {string}
 * @notypecheck
 */
oo.diplomka.templates.skeleton = function(opt_data, opt_ignored) {
  return '<div id="split-container" class="goog-splitpane"><textarea class="goog-splitpane-first-container" id="text-input" spellcheck="false"></textarea><div class="goog-splitpane-second-container" id="split-second"><div id="tags-container"><div id="tags"></div><input id="tags-input" placeholder="Add tags..."><b>Suggested tags: </b> <span id="suggested-tags"></span></div><div id="images-container"></div></div><div class="goog-splitpane-handle" id="split-handle"></div></div>';
};


/**
 * @param {Object.<string, *>=} opt_data
 * @param {(null|undefined)=} opt_ignored
 * @return {string}
 * @notypecheck
 */
oo.diplomka.templates.images = function(opt_data, opt_ignored) {
  var output = '<b>' + soy.$$escapeHtml(opt_data.images.hits.total) + ' hits</b><br>';
  var hitList12 = opt_data.images.hits.hits;
  var hitListLen12 = hitList12.length;
  for (var hitIndex12 = 0; hitIndex12 < hitListLen12; hitIndex12++) {
    var hitData12 = hitList12[hitIndex12];
    output += '<a href="http://www.profimedia.cz/image/detail/' + soy.$$escapeHtml(hitData12._id) + '" target="_blank"><img src="/http://www.profimedia.cz/image/dynamicPreview/' + soy.$$escapeHtml(hitData12._id) + '" height="200" alt="' + soy.$$escapeHtml(hitData12._source.keywords) + '" class="img-result"></a>';
  }
  return output;
};


/**
 * @param {Object.<string, *>=} opt_data
 * @param {(null|undefined)=} opt_ignored
 * @return {string}
 * @notypecheck
 */
oo.diplomka.templates.tags = function(opt_data, opt_ignored) {
  var output = '';
  var tagList22 = opt_data.tags;
  var tagListLen22 = tagList22.length;
  for (var tagIndex22 = 0; tagIndex22 < tagListLen22; tagIndex22++) {
    var tagData22 = tagList22[tagIndex22];
    output += '<span data-tag="' + soy.$$escapeHtml(tagData22) + '" class="tag tag-own">' + soy.$$escapeHtml(tagData22) + '</span>';
  }
  return output;
};


/**
 * @param {Object.<string, *>=} opt_data
 * @param {(null|undefined)=} opt_ignored
 * @return {string}
 * @notypecheck
 */
oo.diplomka.templates.suggestedTags = function(opt_data, opt_ignored) {
  var output = '';
  var tagList30 = opt_data.tags;
  var tagListLen30 = tagList30.length;
  for (var tagIndex30 = 0; tagIndex30 < tagListLen30; tagIndex30++) {
    var tagData30 = tagList30[tagIndex30];
    output += '<span data-tag="' + soy.$$escapeHtml(tagData30) + '" class="tag tag-suggested">' + soy.$$escapeHtml(tagData30) + '</span>';
  }
  return output;
};
