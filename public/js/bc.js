function startReceiveBroadcast() {
    console.log("start receive bc: ",CHAT_URL);
    if(CHAT_URL && CHAT_URL.trim().length > 0) {
        var socket = io.connect(CHAT_URL);
        socket.on('broadcast-message', function(msg) {
            console.log("broadcast-message:",msg);
            let div = $("<div class='bc-layer'></div>");
            let link = $("<a href=\"javascript:void(0)\" class=\"bc-close\" aria-label=\"close\"></a>").html("<em class='fa fa-close'></em>");
            link.click(function() { div.remove(); });
            let span = $("<span></span>").html(msg.message);
            div.append(link).append(span).appendTo($("body"));
        });
    }
}