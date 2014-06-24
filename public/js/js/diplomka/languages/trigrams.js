goog.provide("oo.diplomka.Languages.Trigrams");

goog.require("oo.diplomka.Languages.Model");

oo.diplomka.Languages.Trigrams = function (opt_languageModel) {
  this.model_ = opt_languageModel || new oo.diplomka.Languages.Model();

}

oo.diplomka.Languages.Trigrams.prototype.detect = function(text) {
  text = text.toLowerCase();
  var trigrams = {};
  for (var i = 0; i <= text.length - 3; i++) {
    var trigram = text.substr(i, 3);
    if (trigram in trigrams) {
      trigrams[trigram] += 1;
    } else {
      trigrams[trigram] = 1;
    }
  }
  var sorted = [];
  for (var trigram in trigrams) sorted.push([trigram, trigrams[trigram]]);

  sorted = sorted.sort(function(a, b) {return b[1] - a[1]});
  sorted = sorted.slice(0, this.model_.getTrigramMaxPenalty());

  var hash = {};
  for (var i = 0; i < sorted.length; i++) {
    hash[sorted[i][0]] = i;
  }

  var results = [];
  this.model_.getLanguages().forEach(function (langCode) {
    var diffValue = 0;
    for (var trigram in hash) {
      diffValue += Math.abs(hash[trigram] - this.model_.getTrigramOrder(langCode, trigram));
    }
    results.push([langCode, diffValue]);
  }, this);

  results = results.sort(function(a, b) {return a[1] - b[1]});
  return results[0][0];

}

