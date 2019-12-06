var curPage = 1;
var pageSize = 3;
var tbody = $('.tbodyBoard');
var templateSrc = $('#tr-template').html();
var trGenerator = Handlebars.compile(templateSrc);

var firstPageLi = $('#firstPage'),
    lastPageLi = $('#lastPage'),
    prevPageLi = $('#prevPage'),
    nextPageLi = $('#nextPage')


// 페이지 로딩
boardList(1);

// 페이지 로딩
function boardList(pn) {

    $.getJSON('/Board/Index?curPage=' + pn + '&pageScale=' + pageSize,
        function (obj) {

            curPage = obj.curPage;
            if (cuPage == 1) {
                firstPageLi.addClass('disabled');
            } else {
                firstPageLi.removeClass('disabled');
            }

            tbody.html('');
            $(trGenerator(obj)).appendTo(tbody);
        });

} // boardList()


