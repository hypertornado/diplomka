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
  return '<div id="split-container" class="goog-splitpane"><textarea class="goog-splitpane-first-container" id="text-input" spellcheck="false"></textarea><div class="goog-splitpane-second-container" id="split-second"><div id="tooltip-container"><div><h1>Here</h1></div></div><div id="tags-container"><div></div><br><input></div><div id="images-container"></div></div><div class="goog-splitpane-handle" id="split-handle"></div></div>';
};


/**
 * @param {Object.<string, *>=} opt_data
 * @param {(null|undefined)=} opt_ignored
 * @return {string}
 * @notypecheck
 */
oo.diplomka.templates.images = function(opt_data, opt_ignored) {
  var output = '<b>' + soy.$$escapeHtml(opt_data.images.response.hits.total) + ' hits</b><br>';
  var hitList12 = opt_data.images.response.hits.hits;
  var hitListLen12 = hitList12.length;
  for (var hitIndex12 = 0; hitIndex12 < hitListLen12; hitIndex12++) {
    var hitData12 = hitList12[hitIndex12];
    output += '<a href="http://www.profimedia.cz/image/detail/' + soy.$$escapeHtml(hitData12._id) + '" target="_blank"><img src="http://mufin.fi.muni.cz/profimedia/images/' + soy.$$escapeHtml(hitData12._id) + '" height="86" class="img-result"></a>';
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
  var tagList20 = opt_data.ownTags;
  var tagListLen20 = tagList20.length;
  for (var tagIndex20 = 0; tagIndex20 < tagListLen20; tagIndex20++) {
    var tagData20 = tagList20[tagIndex20];
    output += '<span data-tag="' + soy.$$escapeHtml(tagData20) + '" class="tag tag-own">' + soy.$$escapeHtml(tagData20) + '</span><span> </span>';
  }
  var tagList27 = opt_data.suggestedTags.tags;
  var tagListLen27 = tagList27.length;
  for (var tagIndex27 = 0; tagIndex27 < tagListLen27; tagIndex27++) {
    var tagData27 = tagList27[tagIndex27];
    output += '<span data-tag="' + soy.$$escapeHtml(tagData27) + '" class="tag tag-suggested">' + soy.$$escapeHtml(tagData27) + '</span><span> </span>';
  }
  return output;
};
