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
  return '<div id="menu-panel"><span id="logo">Stock Photo Finder</span><span id="menu-right"><span id="options-panel"></span><span id="hits-container"></span></span></div><div id="split-container" class="goog-splitpane"><div class="goog-splitpane-first-container" id="split-first"><textarea id="text-input" spellcheck="false"></textarea></div><div class="goog-splitpane-second-container" id="split-second"><div id="tags-container"><div id="tags"></div><input id="tags-input" placeholder="Add tags..." spellcheck="false"><b>Suggested tags: </b> <span id="suggested-tags"></span></div><div id="images-container"><div id="images"></div></div></div><div class="goog-splitpane-handle" id="split-handle"></div></div>';
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
    output += '<a href="http://www.profimedia.cz/image/detail/' + soy.$$escapeHtml(hitData9._id) + '" target="_blank" class="img-container"><div style="background-image: url(\'http://mufin.fi.muni.cz/profimedia/bigImages/' + soy.$$escapeHtml(hitData9._id) + '\')" alt="' + soy.$$escapeHtml(hitData9._source.keywords) + '" class="image"></div><span class="img-metadata"><span class="img-name">' + soy.$$escapeHtml(hitData9._source.title) + '</span><span class="img-tags">' + soy.$$escapeHtml(hitData9._source.keywords) + '</span></span></a>';
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
  var tagList23 = opt_data.tags;
  var tagListLen23 = tagList23.length;
  for (var tagIndex23 = 0; tagIndex23 < tagListLen23; tagIndex23++) {
    var tagData23 = tagList23[tagIndex23];
    output += '<span data-tag="' + soy.$$escapeHtml(tagData23) + '" class="tag tag-own">' + soy.$$escapeHtml(tagData23) + '</span><span> </span>';
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
  var tagList31 = opt_data.tags;
  var tagListLen31 = tagList31.length;
  for (var tagIndex31 = 0; tagIndex31 < tagListLen31; tagIndex31++) {
    var tagData31 = tagList31[tagIndex31];
    output += '<span data-tag="' + soy.$$escapeHtml(tagData31) + '" class="tag tag-suggested">' + soy.$$escapeHtml(tagData31) + '</span>';
  }
  return output;
};


/**
 * @param {Object.<string, *>=} opt_data
 * @param {(null|undefined)=} opt_ignored
 * @return {string}
 * @notypecheck
 */
oo.diplomka.templates.optionsPane = function(opt_data, opt_ignored) {
  var output = soy.$$escapeHtml(opt_data.wordCount) + ' words in<select id="language-select">';
  var languageList41 = opt_data.languages;
  var languageListLen41 = languageList41.length;
  for (var languageIndex41 = 0; languageIndex41 < languageListLen41; languageIndex41++) {
    var languageData41 = languageList41[languageIndex41];
    output += '<option value="' + soy.$$escapeHtml(languageData41) + '" ' + ((opt_data.selectedLanguage == languageData41) ? 'selected' : '') + '>' + soy.$$escapeHtml(opt_data.languageNames[languageData41]) + '</option>';
  }
  output += '</select>language';
  return output;
};
