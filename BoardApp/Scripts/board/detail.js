var param = location.href.split('?')[1],
    boardNo = param.split('=')[1];

var commentBody = $('.comment-view');

var commentTemplateSrc = $('#comment-template').html(),
    cmtGenerator = Handlebars.compile(commentTemplateSrc);


// 댓글 리스트 로딩
function commentList(bno) {

    $.getJSON('/Comment/Index?boardNo=' + bno,
        function (obj) {
            console.log(obj);
            commentBody.html('');
            $(cmtGenerator(obj)).appendTo(commentBody);

            for (cmtlistRow of $('.comment-listRow')) {
                if (cmtlistRow.getAttribute('comment-level') != 0) {
                    $(cmtlistRow).addClass('indent-right');
                    $(cmtlistRow).prepend('<span style="position:absolute">&#8627;</span>');

                }
               
            }
            
            for (parentWriterRow of $('.comment-parentCommentWriter')) {
                if (parentWriterRow.getAttribute('parent-commentWriter') == '0') {
                    parentWriterRow.remove();
                }
            }
            


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

