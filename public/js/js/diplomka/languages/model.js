goog.provide("oo.diplomka.Languages.Model");

goog.require("oo.diplomka.Languages.Data");

oo.diplomka.Languages.Model = function() {
  this.data_ = new oo.diplomka.Languages.Data();
  this.hashes_ = {};
  this.trigramMaxPenalty_ = Number.MAX_VALUE;
  this.createHashes_();
}

oo.diplomka.Languages.Model.prototype.createHashes_ = function() {
  this.data_.languages.forEach(function (language) {
    var trigramsOrder = {};
    var trigrams = this.data_.trigrams[language];
    var penalty = trigrams.length;
    for (var i = 0; i < penalty; i++) {
      trigramsOrder[trigrams[i]] = i;
    }
    this.hashes_[language] = trigramsOrder;
    this.trigramMaxPenalty_ = Math.min(this.trigramMaxPenalty_, penalty);
  }, this);
}

oo.diplomka.Languages.Model.prototype.getTrigramOrder = function (language, trigram) {
  if (this.hashes_[language] === undefined) return this.trigramMaxPenalty_;
  if (this.hashes_[language][trigram] === undefined) return this.trigramMaxPenalty_;
  return this.hashes_[language][trigram];
}

oo.diplomka.Languages.Model.prototype.getTrigramMaxPenalty = function () {
  return this.trigramMaxPenalty_;
}

oo.diplomka.Languages.Model.prototype.getLanguages = function () {
  return this.data_.languages;
}

oo.diplomka.Languages.Model.prototype.countWords = function (text) {
  if (text == "") return 0;
  return text.split(" ").length
}

oo.diplomka.Languages.Model.prototype.getLanguageNames = function () {
  return this.data_.languageNames
}

