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
  return '<div id="split-container" class="goog-splitpane"><textarea class="goog-splitpane-first-container" id="text-input" spellcheck="false"></textarea><div class="goog-splitpane-second-container" id="split-second"><div id="tags-container"><div id="tags"></div><input id="tags-input" placeholder="Add tags..." spellcheck="false"><b>Suggested tags: </b> <span id="suggested-tags"></span></div><div id="images-container"><div id="hits-container"></div><div id="images"></div></div></div><div class="goog-splitpane-handle" id="split-handle"></div></div>';
};


/**
 * @param {Object.<string, *>=} opt_data
 * @param {(null|undefined)=} opt_ignored
 * @return {string}
 * @notypecheck
 */
oo.diplomka.templates.images = function(opt_data, opt_ignored) {
  var output = '';
  var hitList9 = opt_data.images.hits.hits;
  var hitListLen9 = hitList9.length;
  for (var hitIndex9 = 0; hitIndex9 < hitListLen9; hitIndex9++) {
    var hitData9 = hitList9[hitIndex9];
    output += '<a href="http://www.profimedia.cz/image/detail/' + soy.$$escapeHtml(hitData9._id) + '" target="_blank" class="img-container"><div style="background-image: url(\'http://www.profimedia.cz/image/dynamicPreview/' + soy.$$escapeHtml(hitData9._id) + '\')" data-src="/image.jpg" src="http://www.profimedia.cz/image/dynamicPreview/' + soy.$$escapeHtml(hitData9._id) + '" alt="' + soy.$$escapeHtml(hitData9._source.keywords) + '" class="image"></div><span class="img-metadata"><span class="img-name">' + soy.$$escapeHtml(hitData9._source.title) + '</span><span class="img-tags">' + soy.$$escapeHtml(hitData9._source.keywords) + '</span></span></a>';
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
  var tagList25 = opt_data.tags;
  var tagListLen25 = tagList25.length;
  for (var tagIndex25 = 0; tagIndex25 < tagListLen25; tagIndex25++) {
    var tagData25 = tagList25[tagIndex25];
    output += '<span data-tag="' + soy.$$escapeHtml(tagData25) + '" class="tag tag-own">' + soy.$$escapeHtml(tagData25) + '</span><span> </span>';
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
  var tagList33 = opt_data.tags;
  var tagListLen33 = tagList33.length;
  for (var tagIndex33 = 0; tagIndex33 < tagListLen33; tagIndex33++) {
    var tagData33 = tagList33[tagIndex33];
    output += '<span data-tag="' + soy.$$escapeHtml(tagData33) + '" class="tag tag-suggested">' + soy.$$escapeHtml(tagData33) + '</span>';
  }
  return output;
};
