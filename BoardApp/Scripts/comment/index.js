var commentBody = $('.comment-view');

var commentTemplateSrc = $('#tr-comment-template').html();
var cmtGenerator = Handlebars.compile(commentTemplateSrc);


// 댓글 리스트 로딩
function commentList(bno) {

    $.getJSON('/Comment/Index?boardNo=' + bno,
        function (obj) {
            //     console.log(obj);
            //console.log('댓글개수' + obj.cmtCount);
            commentBody.html('');
            $(cmtGenerator(obj)).appendTo(commentBody);

            $('.commment-count').html('댓글 ' + obj.cmtCount + '개');

            for (cmtlistRow of $('.comment-listRow')) {
                if (cmtlistRow.getAttribute('comment-level') != 0) {
                    $(cmtlistRow).addClass('indent-right');
                    $(cmtlistRow).prepend('<span style="position:absolute">&#8627;</span>');

                }

                if ($(cmtlistRow).attr('flag') == 1) {
                    $(cmtlistRow).html('<div class="removedComment">삭제 된 댓글입니다<div>');
                }

                if (cmtlistRow.getAttribute('comment-level') == 0) {
                    $(cmtlistRow).children().next().children().first().remove()
                }
            }

            //for (parentWriterRow of $('.comment-parentCommentWriter')) {
            //    if (parentWriterRow.getAttribute('parent-commentWriter') == '0') {
            //        parentWriterRow.remove();
            //    }
            //}




            $(document.body).trigger('loaded-commentlist');

        }

    )
} // commentList()

commentList(boardNo);