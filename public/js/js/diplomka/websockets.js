
goog.provide('oo.diplomka.websockets');

goog.require("oo.diplomka.Events");

oo.diplomka.WebSockets = function(events) {
    this.events = events;
    this.events.listen(oo.diplomka.EventType.TEXT_CHANGE, this.textChange, this);
    this.events.listen(oo.diplomka.EventType.GET_IMAGES, this.getImages, this);
	this.connect();
}

oo.diplomka.WebSockets.prototype.connect = function() {
    
	var ws = new WebSocket("ws://localhost:8585/ws");
    this.ws = ws;
    self = this;
    ws.onmessage = function (evt) 
     {
        var received_msg = JSON.parse(evt.data);

        switch (received_msg.method) {
            case "gettags":
                self.events.fire(oo.diplomka.EventType.RECEIVE_TAGS, received_msg.payload);
                break;
            case "getimages":
                self.events.fire(oo.diplomka.EventType.RECEIVE_IMAGES, received_msg.payload);
                break;
            default:
                window.console.error("no handler for method ", received_msg.method);
                break;
        }
     };
    ws.onclose = function()
     {
        window.console.log("Connection is closed..."); 
    };
}

oo.diplomka.WebSockets.prototype.sendRequest = function (method, data) {
    if (this.ws == undefined || this.ws.readyState != 1) {
        window.console.log("not connected");
        return;
    }

    var request = {
        "method": method,
        "payload": JSON.stringify(data)
    };

    this.ws.send(JSON.stringify(request))
}


oo.diplomka.WebSockets.prototype.getImages = function(tags) {
    var req = {
        "tags": tags
    };
    this.sendRequest("getimages", req);
}

oo.diplomka.WebSockets.prototype.textChange = function(text) {

    var request = {
        "text": text
    };

    this.sendRequest("gettags", request);
}
