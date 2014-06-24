goog.provide("oo.diplomka.Languages.Trigrams");

goog.require("oo.diplomka.Languages.TrigramsData");

oo.diplomka.Languages.Trigrams = function () {

  this.lang_ = {};

  this.lang_["cs"] = oo.diplomka.Languages.TrigramsData.cs;
  this.lang_["en"] = oo.diplomka.Languages.TrigramsData.en;
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
  
  console.log(sorted);
}

