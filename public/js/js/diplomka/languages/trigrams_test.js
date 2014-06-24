goog.provide("oo.diplomka.Languages.TrigramsTest");

goog.setTestOnly('oo.diplomka.Languages.TrigramsTest');
goog.require('goog.testing.jsunit');
goog.require("oo.diplomka.Languages.Trigrams");

function testTrigrams() {
  assertEquals(true, true);
  var trigrams = new oo.diplomka.Languages.Trigrams();
  trigrams.detect("abababbab");

}