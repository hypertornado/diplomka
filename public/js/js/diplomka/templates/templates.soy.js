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
  return '<div id="split-container" class="goog-splitpane"><textarea class="goog-splitpane-first-container" id="text-input" spellcheck="false"></textarea><div class="goog-splitpane-second-container" id="split-second"><div id="tags-container"><div id="tags"></div><input id="tags-input" placeholder="Add tags..." spellcheck="false"><b>Suggested tags: </b> <span id="suggested-tags"></span></div><div id="images-container"></div></div><div class="goog-splitpane-handle" id="split-handle"></div></div>';
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
    output += '<a href="http://www.profimedia.cz/image/detail/' + soy.$$escapeHtml(hitData12._id) + '" target="_blank" class="img-container"><img data-src="/image.jpg" src="http://www.profimedia.cz/image/dynamicPreview/' + soy.$$escapeHtml(hitData12._id) + '" height="200" alt="' + soy.$$escapeHtml(hitData12._source.keywords) + '"><span class="img-metadata"><span class="img-name">' + soy.$$escapeHtml(hitData12._source.title) + '</span><span class="img-tags">' + soy.$$escapeHtml(hitData12._source.keywords) + '</span></span></a>';
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
  var tagList26 = opt_data.tags;
  var tagListLen26 = tagList26.length;
  for (var tagIndex26 = 0; tagIndex26 < tagListLen26; tagIndex26++) {
    var tagData26 = tagList26[tagIndex26];
    output += '<span data-tag="' + soy.$$escapeHtml(tagData26) + '" class="tag tag-own">' + soy.$$escapeHtml(tagData26) + '</span><span> </span>';
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
  var tagList34 = opt_data.tags;
  var tagListLen34 = tagList34.length;
  for (var tagIndex34 = 0; tagIndex34 < tagListLen34; tagIndex34++) {
    var tagData34 = tagList34[tagIndex34];
    output += '<span data-tag="' + soy.$$escapeHtml(tagData34) + '" class="tag tag-suggested">' + soy.$$escapeHtml(tagData34) + '</span>';
  }
  return output;
};
