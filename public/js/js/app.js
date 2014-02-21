goog.provide('app.start');

goog.require('oo.diplomka.StockPhotoFinder');

app.start = function() {
	new oo.diplomka.StockPhotoFinder();
};

goog.exportSymbol('app.start', app.start);
