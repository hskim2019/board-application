// 댓글 삭제
$(document).on("click", '.comment-deleteBtn', function () {
    event.preventDefault();
    var commentID = $(this).parents('.comment-listRow').attr('comment-no');
    var commentLevel = $(this).parents('.comment-listRow').attr('comment-level');


    Swal.fire({
        title: '비밀 번호를 입력 해 주세요.',
        //text: "",
        //icon: 'warning',
        showCancelButton: true,
        cancelButtonColor: '#d33',
        confirmButtonColor: '#3085d6',
        cancelButtonText: '취소',
        confirmButtonText: '확인',
        input: 'password',
        inputPlaceholder: '비밀번호를 입력 해 주세요',
        inputAttributes: {
            maxlength: 20,
            autocapitalize: 'off',
            autocorrect: 'off'
        }

    }).then((result) => {
        
        if (result.value) {

            $.post('/Comment/Delete', {

                CommentNo: commentID,
                Password: result.value,
                CommentLevel: commentLevel

            },
                function (data) {

                    //alert(data.status);

                    if (data.status == 'success') {
                        Swal.fire(

                            '삭제완료!',
                            '댓글을 삭제하였습니다.',
                            'success'

                        )
                        $('.swal2-confirm').click((e) => {
                            e.preventDefault();
                            commentList(boardNo);
                        });
                    } else {
                        //alert('삭제 실패 입니다.\n' + data.message);
                        Swal.fire({
                            icon: 'error',
                            title: '삭제 실패 입니다',
                            text: data.message,
                        })
                        //$('.swal2-confirm').click((e) => {
                        //    e.preventDefault();

                        //});
                    }
                });

        }
    })



});