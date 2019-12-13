var param = location.href.split('?')[1],
    boardNo = param.split('=')[1];

var commentBody = $('.comment-view');

var commentTemplateSrc = $('#comment-template').html(),
    cmtGenerator = Handlebars.compile(commentTemplateSrc);


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

$('#boardDelete-button').click((e) => {
    var boardNo = $('#boardDelete-button').attr('data-no');

    Swal.fire({
        title: '게시글을 삭제하시겠습니까?',
        text: "",
        icon: 'warning',
        showCancelButton: true,
        cancelButtonColor: '#d33',
        confirmButtonColor: '#3085d6',
        cancelButtonText: '취소',
        confirmButtonText: '확인'
    }).then((result) => {

        if (result.value) {

            $.getJSON('/Board/Delete?BoardNo=' + boardNo,
                function (data) {

                    //alert(data.status);

                    if (data.status == 'success') {
                        Swal.fire(

                            '삭제완료!',
                            '해당 글을 삭제하였습니다.',
                            'success'

                        )
                        $('.swal2-confirm').click((e) => {
                            e.preventDefault();
                            location.href = "Index";
                        });
                    } else {
                        //alert('삭제 실패 입니다.\n' + data.message);
                        Swal.fire({
                            icon: 'error',
                            title: '삭제 실패 입니다',
                            text: data.message,
                        })
                        $('.swal2-confirm').click((e) => {
                            e.preventDefault();
                            location.href = "Index";
                        });
                    }
                });

        }
    })
});

