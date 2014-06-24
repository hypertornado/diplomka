goog.provide("oo.diplomka.Languages.TrigramsTest");

goog.setTestOnly('oo.diplomka.Languages.TrigramsTest');
goog.require('goog.testing.jsunit');
goog.require("oo.diplomka.Languages.Trigrams");

function testTrigrams() {
  assertEquals(true, true);
  var trigrams = new oo.diplomka.Languages.Trigrams();
  var texts = [
    ["en", "hello world, how are you today?"],
    ["en", "The US secretary of state is in northern Iraq holding talks with Kurdish leaders, as Sunni rebels claim a key oil refinery has fallen to them."],
    ["cs", "dobře se dnes máme tady, a jakpak se máte?"],
    ["cs", "Ve středu zasáhnou východní Čechy a Moravu silné bouřky, varují meteorologové. Místy má napršet až 40 mm, vát"],
  ];

  texts.forEach(function (data) {
    assertEquals(data[0], trigrams.detect(data[1]));
  }, this);

}