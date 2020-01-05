var param = location.href.split('?')[1],
    boardNo = param.split('=')[1];

//$(document).on('click', '#detail-returnToIndex', function () {
//    event.preventDefault();
//    history.go(-1);
//    //boardList(1);
//});

$(document).ready(function () {

    if ($('img')) {
        var img = $('img');
        
        var width = img.outerWidth();
        if (width >= 608) {
            img.css("width", "608");
        }

    }

});