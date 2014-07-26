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
  return '<div id="menu-panel"><span id="logo">Stock Photo Finder</span><span id="menu-right"><span id="options-panel"></span><span id="hits-container"></span></span></div><div id="split-container" class="goog-splitpane"><div class="goog-splitpane-first-container" id="split-first"><textarea id="text-input" spellcheck="false"></textarea></div><div class="goog-splitpane-second-container" id="split-second"><div id="tags-container"><div id="tags"></div><input id="tags-input" placeholder="Add tags..." spellcheck="false"><b>Suggested tags: </b> <span id="suggested-tags"></span></div><div id="images-container"><div id="images"></div></div></div><div class="goog-splitpane-handle" id="split-handle"></div><div class="img-detail hide" id="img-detail"></div></div>';
};


/**
 * @param {Object.<string, *>=} opt_data
 * @param {(null|undefined)=} opt_ignored
 * @return {string}
 * @notypecheck
 */
oo.diplomka.templates.imageDetails = function(opt_data, opt_ignored) {
  return '<div class="img-info" id="img-info"><h3><small>' + soy.$$escapeHtml(opt_data.id) + '</small></h3></div><div class="img"><img src="http://mufin.fi.muni.cz/profimedia/bigImages/' + soy.$$escapeHtml(opt_data.id) + '"></div><div class="img-similar" id="img-similar"></div>';
};


/**
 * @param {Object.<string, *>=} opt_data
 * @param {(null|undefined)=} opt_ignored
 * @return {string}
 * @notypecheck
 */
oo.diplomka.templates.imageDetailsMetadata = function(opt_data, opt_ignored) {
  return '<h3>' + soy.$$escapeHtml(opt_data.data['_source']['title']) + '<small> ' + soy.$$escapeHtml(opt_data.data['_id']) + '</small></h3><p>' + soy.$$escapeHtml(opt_data.data['_source']['keywords']) + '</p><a target="_blank" class="btn btn-default" href="http://www.profimedia.cz/image/detail/' + soy.$$escapeHtml(opt_data.data['_id']) + '">Detail na Profimedia.cz</a><a href="#" class="btn btn-default" id="close-img-window">Zavřít</a>';
};


/**
 * @param {Object.<string, *>=} opt_data
 * @param {(null|undefined)=} opt_ignored
 * @return {string}
 * @notypecheck
 */
oo.diplomka.templates.suggestedImages = function(opt_data, opt_ignored) {
  var output = '';
  var imgList25 = opt_data.data;
  var imgListLen25 = imgList25.length;
  for (var imgIndex25 = 0; imgIndex25 < imgListLen25; imgIndex25++) {
    var imgData25 = imgList25[imgIndex25];
    output += '<img src="http://mufin.fi.muni.cz/profimedia/bigImages/' + soy.$$escapeHtml(imgData25) + '" class="suggested-image" data-id="' + soy.$$escapeHtml(imgData25) + '">';
  }
  return output;
};


/**
 * @param {Object.<string, *>=} opt_data
 * @param {(null|undefined)=} opt_ignored
 * @return {string}
 * @notypecheck
 */
oo.diplomka.templates.images = function(opt_data, opt_ignored) {
  var output = '';
  var hitList33 = opt_data.images.hits.hits;
  var hitListLen33 = hitList33.length;
  for (var hitIndex33 = 0; hitIndex33 < hitListLen33; hitIndex33++) {
    var hitData33 = hitList33[hitIndex33];
    output += '<a href="#" class="img-container" data-id="' + soy.$$escapeHtml(hitData33._id) + '"><div style="background-image: url(\'http://mufin.fi.muni.cz/profimedia/bigImages/' + soy.$$escapeHtml(hitData33._id) + '\')" alt="' + soy.$$escapeHtml(hitData33._source.keywords) + '" class="image"></div><span class="img-metadata"><span class="img-name">' + soy.$$escapeHtml(hitData33._source.title) + '</span><span class="img-tags">' + soy.$$escapeHtml(hitData33._source.keywords) + '</span></span></a>';
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
  var tagList47 = opt_data.tags;
  var tagListLen47 = tagList47.length;
  for (var tagIndex47 = 0; tagIndex47 < tagListLen47; tagIndex47++) {
    var tagData47 = tagList47[tagIndex47];
    output += '<span data-tag="' + soy.$$escapeHtml(tagData47) + '" class="tag tag-own">' + soy.$$escapeHtml(tagData47) + '</span><span> </span>';
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
  var tagList55 = opt_data.tags;
  var tagListLen55 = tagList55.length;
  for (var tagIndex55 = 0; tagIndex55 < tagListLen55; tagIndex55++) {
    var tagData55 = tagList55[tagIndex55];
    output += '<span data-tag="' + soy.$$escapeHtml(tagData55) + '" class="tag tag-suggested">' + soy.$$escapeHtml(tagData55) + '</span>';
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
  var languageList65 = opt_data.languages;
  var languageListLen65 = languageList65.length;
  for (var languageIndex65 = 0; languageIndex65 < languageListLen65; languageIndex65++) {
    var languageData65 = languageList65[languageIndex65];
    output += '<option value="' + soy.$$escapeHtml(languageData65) + '" ' + ((opt_data.selectedLanguage == languageData65) ? 'selected' : '') + '>' + soy.$$escapeHtml(opt_data.languageNames[languageData65]) + '</option>';
  }
  output += '</select>language';
  return output;
};
