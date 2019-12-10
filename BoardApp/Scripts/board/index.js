var curPage = 1;
var pageSize = 10;
var tbody = $('.tbodyBoard');
var templateSrc = $('#tr-template').html();
var trGenerator = Handlebars.compile(templateSrc);

var firstPageLi = $('#firstPage'),
    lastPageLi = $('#lastPage'),
    prevPageLi = $('#prevPage'),
    nextPageLi = $('#nextPage')

var blockBegin,
    blockEnd,
    curBlock,
    totalBlock,
    totalPage,
    rowCount;


// 페이지 로딩
function boardList(pn) {

    $.getJSON('/Board/Index?curPage=' + pn + '&pageScale=' + pageSize,
        function (obj) {
            //     $.ajaxSetup({ async: false });
            console.log(obj);
            curPage = obj.boardPager.CurPage;
            console.log('curPage=' + curPage);
            blockBegin = obj.boardPager.BlockBegin;
            blockEnd = obj.boardPager.BlockEnd;
            curBlock = obj.boardPager.CurBlock;
            totalBlock = obj.boardPager.TotalBlock;
            totalPage = obj.boardPager.TotalPage;
            rowCount = obj.rowCount;
            //console.log("blockBegin= " + blockBegin);
            //console.log("blockEnd= " + blockEnd);

            //console.log("curBlock=" + curBlock);
            //console.log("totalBlock= " + totalBlock);

            tbody.html('');
            $(trGenerator(obj)).appendTo(tbody);

            for (list of $('.commentCnt')) {
                if (list.getAttribute('data') == 0) {
                    list.remove();
                }
            }




            if (curPage == 1) {
                firstPageLi.addClass('disabled');
                prevPageLi.addClass('disabled');
            } else {
                firstPageLi.removeClass('disabled');
                prevPageLi.removeClass('disabled');
            }

            if (curPage == totalPage) {
                nextPageLi.addClass('disabled');
            } else {
                nextPageLi.removeClass('disabled');
            }

            if (curPage == totalPage) {
                lastPageLi.addClass('disabled');
            } else {
                lastPageLi.removeClass('disabled');
            }

            var pageButtons = "";
            var curPageButtons = '';
            var pageButtonsHtml = '';
            // 블록의 시작, 끝 넣어주기



            for (var i = blockBegin; i <= blockEnd; i++) {
                pageButtonsHtml = "<a class='page-link page-block' href='#' page-no='" + i + "' id='page-number'>" + i + "</a>";

                if (i == curPage) {
                    pageButtonsHtml = "<a class='page-link page-block' href='#' page-no='" + i + "' id='currentPage'>" + i + "</a>";
                }

                pageButtons += pageButtonsHtml;
            }


            $('#pageButtons').html(pageButtons);


            //$('#nextPage').before(pageButtons);



            $(document.body).trigger('loaded-list');

            // $.ajaxSetup({ async: true });
        }

    );


} // boardList()

// 페이지 로딩
boardList(1);

$(document.body).bind('loaded-list', () => {


    $('.page-block').click((e) => {
        e.preventDefault();
        curPage = e.target.getAttribute('page-no');
        boardList(curPage);
    });


});


    $('#prevPage > a').click((e) => {
        e.preventDefault();
       // console.log('이전페이지 클릭, curPage=' + curPage);
       // console.log("이전페이지 클릭 curPage=" + curPage);
        if (curPage <= 1) {
            curPage = 1;
            return;
        } else {
        curPage = curPage - 1;
        boardList(curPage);
        }
    });

$(nextPageLi).click((e) => {
    
    e.preventDefault();
    if (curPage >= totalPage) {
        curPage = totalPage;
        return;
    } else {

    curPage = curPage + 1;
    boardList(curPage);
    }
});


$('#firstPage > a').click((e) => {
    e.preventDefault();
    boardList(1);
});

$('#lastPage > a').click((e) => {
    e.preventDefault();
    boardList(totalPage);
});


$('.dropdown-toggle').dropdown();

$(function () {

    $(".dropdown-menu").on('click', 'li a', function () {
        event.preventDefault();
        //$(".btn:first-child").text($(this).text());
        //$(".btn:first-child").val($(this).text());
        $('#selected-pageSize').text($(this).text());
        pageSize = $(this).attr('value');

        boardList(1);

    });

});