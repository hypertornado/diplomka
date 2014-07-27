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
  return '<div class="img-info" id="img-info"><div id="img-info-meta"><h3><small>' + soy.$$escapeHtml(opt_data.id) + '</small></h3></div><a target="_blank" class="btn btn-default" href="http://www.profimedia.cz/image/detail/' + soy.$$escapeHtml(opt_data.id) + '">Detail na Profimedia.cz</a><a href="#" class="btn btn-default" id="close-img-window">Zavřít</a></div><div class="img"><img src="http://mufin.fi.muni.cz/profimedia/bigImages/' + soy.$$escapeHtml(opt_data.id) + '"></div><div class="img-similar" id="img-similar"></div>';
};


/**
 * @param {Object.<string, *>=} opt_data
 * @param {(null|undefined)=} opt_ignored
 * @return {string}
 * @notypecheck
 */
oo.diplomka.templates.imageDetailsMetadata = function(opt_data, opt_ignored) {
  return '<h3>' + soy.$$escapeHtml(opt_data.data['_source']['title']) + '<small> ' + soy.$$escapeHtml(opt_data.data['_id']) + '</small></h3><p>' + soy.$$escapeHtml(opt_data.data['_source']['keywords']) + '</p>';
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
    output += (imgData25.score > 0) ? '<img src="http://mufin.fi.muni.cz/profimedia/bigImages/' + soy.$$escapeHtml(imgData25.id) + '" class="suggested-image" data-id="' + soy.$$escapeHtml(imgData25.id) + '" title="' + soy.$$escapeHtml(imgData25.id) + ' ' + soy.$$escapeHtml(imgData25.score) + '">' : '';
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
  var hitList39 = opt_data.images.hits.hits;
  var hitListLen39 = hitList39.length;
  for (var hitIndex39 = 0; hitIndex39 < hitListLen39; hitIndex39++) {
    var hitData39 = hitList39[hitIndex39];
    output += '<a href="#" class="img-container" data-id="' + soy.$$escapeHtml(hitData39._id) + '"><div style="background-image: url(\'http://mufin.fi.muni.cz/profimedia/bigImages/' + soy.$$escapeHtml(hitData39._id) + '\')" alt="' + soy.$$escapeHtml(hitData39._source.keywords) + '" class="image"></div><span class="img-metadata"><span class="img-name">' + soy.$$escapeHtml(hitData39._source.title) + '</span><span class="img-tags">' + soy.$$escapeHtml(hitData39._source.keywords) + '</span></span></a>';
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
  var tagList53 = opt_data.tags;
  var tagListLen53 = tagList53.length;
  for (var tagIndex53 = 0; tagIndex53 < tagListLen53; tagIndex53++) {
    var tagData53 = tagList53[tagIndex53];
    output += '<span data-tag="' + soy.$$escapeHtml(tagData53) + '" class="tag tag-own">' + soy.$$escapeHtml(tagData53) + '</span><span> </span>';
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
  var tagList61 = opt_data.tags;
  var tagListLen61 = tagList61.length;
  for (var tagIndex61 = 0; tagIndex61 < tagListLen61; tagIndex61++) {
    var tagData61 = tagList61[tagIndex61];
    output += '<span data-tag="' + soy.$$escapeHtml(tagData61) + '" class="tag tag-suggested">' + soy.$$escapeHtml(tagData61) + '</span>';
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
  var languageList71 = opt_data.languages;
  var languageListLen71 = languageList71.length;
  for (var languageIndex71 = 0; languageIndex71 < languageListLen71; languageIndex71++) {
    var languageData71 = languageList71[languageIndex71];
    output += '<option value="' + soy.$$escapeHtml(languageData71) + '" ' + ((opt_data.selectedLanguage == languageData71) ? 'selected' : '') + '>' + soy.$$escapeHtml(opt_data.languageNames[languageData71]) + '</option>';
  }
  output += '</select>language';
  return output;
};
