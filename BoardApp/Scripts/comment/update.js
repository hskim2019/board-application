﻿var commentUpdateTemplate = $('#comment-update-template').html();

var updateCommentNo;
var updateCommentWriter;
var originData;

$(document).on('click', '.comment-updateBtn', function () {

    event.preventDefault();

    

    // 대댓글 창 없애주기
    for (pre of $('#reCommentForm')) {
        pre.remove();
    }

    // 이미 댓글수정창이 있으면 원래 댓글 복구 + 수정창 없애주기
    for (pre of $('#commentUpdatePanel')) {
        //  pre.remove();
        if (pre) {
            //originData.removeClass('b-invisible');
            $(pre).parent().prepend(originData);
        }
        pre.remove();
    }



    // 업데이트 할 내용 : 댓글 내용만
    // 파라미터는 CommentNo, CommentContent, Password

    // 수정form에 표시 할 것 : 작성자, 원래내용
    updateCommentNo = $(this).parents('.comment-listRow').attr('comment-no');
    //updateCommentWriter = $(this).parent().siblings('span').html();
    updateCommentWriter = $(this).parent().siblings('span').first().text();
    
    //var originContent = $(this).parent().parent().next().children('.comment-body').children('.comment-content').html();
    var originContent = $(this).parent().parent().next().children('.comment-body').children('.comment-content').text();
    //console.log(originContent);

    originData = $(this).parents('.comment-listRow').html();
    $(this).parents('.comment-listRow').html(commentUpdateTemplate);
    //originData.addClass('b-invisible');
    //originData.after(commentUpdateTemplate);
    //$(this).parents('.comment-listRow').append(commentUpdateTemplate);


   

    $('#comment-updateWriter').val(updateCommentWriter);
    $('#comment-updateContent').val(originContent);
});


// 댓글 수정 취소
$(document).on('click', '#comment-updateCancel-btn', function () {
    for (pre of $('#commentUpdatePanel')) {
        //  pre.remove();
        if (pre) {
            $(pre).parent().prepend(originData);
        }
        pre.remove();
    }
});

// 댓글 수정 등록
$(document).on('click', '#comment-update-btn', function () {
    event.preventDefault();

    var cmtContent = $('#comment-updateContent');
    var cmtPassword = $('#comment-updatePassword');

    var a = noWhiteSpace(cmtContent);
    var b = noWhiteSpace(cmtPassword);


    var commentContent = cmtContent.val();
    var commentPassword = cmtPassword.val();

    if (a & b) {
        $.post('/Comment/Update', {

            CommentNo: updateCommentNo,
            CommentContent: commentContent,
            CommentPassword: commentPassword
        }, function (updateData) {
            if (updateData.status == 'success') {
                Swal.fire(
                    '수정완료!',
                    '댓글이 수정 되었습니다.',
                    'success'
                )
                $('.swal2-confirm').click((e) => {
                    e.preventDefault();
                    //location.href = "/Board/Detail?boardNo=" + boardNo;
                    commentList(boardNo);

                });
            } else {
                Swal.fire({
                    type: 'error',
                    title: '수정 실패 입니다',
                    text: updateData.message
                })

                //$('.swal2-confirm').click((e) => {
                //    e.preventDefault();
                //    //location.href = "Index";
                //    history.go(-1);
                //});

                //commentList(boardNo);
            }
        });
    }
});