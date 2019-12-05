var curPage = 1;
var pageSize = 3;
var tbody = $('.tbodyBoard');
var templateSrc = $('#tr-template').html();
var trGenerator = Handlebars.compile(templateSrc);



boardList(1);

function boardList(pn) {
    $.getJSON('/Board/Index?curPage=' + pn + '&pageScale=' + pageSize,
        function (obj) {
            console.log(obj.boardPager);

            tbody.html('');
            $(trGenerator(obj)).appendTo(tbody);
        });

} // boardList()
