var commentReplyEditor = $('#comment-editor-template').html();


// 답변하기 click시 답변 창
$(document).on("click", '.comment-replyBtn', function () {
    event.preventDefault();
   // console.log($(this).parents('.comment-listRow'));

    for (pre of $('#reCommentForm')) {
        pre.remove();
    }

    for (pre of $('#commentUpdatePanel')) {
        //  pre.remove();
        if (pre) {
            //originData.removeClass('b-invisible');
            $(pre).parent().prepend(originData);
        }
        pre.remove();
    }


    $(this).parents('.comment-listRow').after(commentReplyEditor);

    //
    $('input, textarea').keydown(function () {
        $(this).next().addClass('b-invisible');
    });

});

$(document).on('click', 'comment-replyCancelBtn', function () {

});



// level 0 댓글 Add
$('#comment-add-btn').click((e) => {
    e.preventDefault();


    var cmtName = $('#comment-inputWriter');
    var cmtPassword = $('#comment-inputPassword');
    var cmtContent = $('#comment-inputContent');

    var a = noWhiteSpace(cmtName);
    var b = noWhiteSpace(cmtPassword);
    var c = noWhiteSpace(cmtContent);
    var d = checkLength(cmtPassword);

    var commentWriter = htmlEncode(cmtName.val());
    var commentPassword = htmlEncode(cmtPassword.val());
    var commentContent = htmlEncode(cmtContent.val());

    if (a && b && c && d) {

        $.post('/Comment/Add', {

            BoardNo: boardNo,
            OriginCommentNo: 0,
            ParentCommentID: 0,
            CommentLevel: 0,
            CommentWriter: commentWriter,
            CommentContent: commentContent,
            CommentPassword: commentPassword


        }, function (cmtData) {
            if (cmtData.status == 'success') {

                Swal.fire(
                    '등록완료!',
                    '댓글이 등록 되었습니다.',
                    'success'
                )
                $('.swal2-confirm').click((e) => {
                    e.preventDefault();
                    //location.href = "/Board/Detail?boardNo=" + boardNo;
                    commentList(boardNo);
                    cmtName.val('');
                    cmtPassword.val('');
                    cmtContent.val('');
                });

            } else {
                Swal.fire({
                    type: 'error',
                    title: '등록 실패 입니다',
                    text: cmtData.message,
                })
                //$('.swal2-confirm').click((e) => {
                //    e.prevantDefault();

                //});
            }
        }

        );

    }


}); // level 0 commentAdd end



// level 1이상 댓글 Add
$(document).on("click", '#reComment-add-btn', function () {

    event.preventDefault();

    var originCmtNo = $('#reCommentForm').prev().attr('origin-commentno');
    var parentCmtID = $('#reCommentForm').prev().attr('comment-no');
    var thisCmtLevel = parseInt($('#reCommentForm').prev().attr('comment-level'));
    
    thisCmtLevel = thisCmtLevel + 1;

    // alert('originCmtNo:'+ originCmtNo + 'parentCmtID:' + parentCmtID + 'thisCmtLevel:' + thisCmtLevel );

    var reCmtName = $('#re-comment-inputWriter');
    var reCmtPassword = $('#re-comment-inputPassword');
    var reCmtContent = $('#re-comment-inputContent');
    //alert(originCmtNo + reCmtName);

    var a = noWhiteSpace(reCmtName);
    var b = noWhiteSpace(reCmtPassword);
    var c = noWhiteSpace(reCmtContent);
    var d = checkLength(reCmtPassword);

    var commentWriter = htmlEncode(reCmtName.val());
    var commentPassword = htmlEncode(reCmtPassword.val());
    var commentContent = htmlEncode(reCmtContent.val());

    if (a && b && c && d) {

        $.post('/Comment/Add', {

            BoardNo: boardNo,
            OriginCommentNo: originCmtNo,
            ParentCommentNo: parentCmtID,
            CommentLevel: thisCmtLevel,
            CommentWriter: commentWriter,
            CommentContent: commentContent,
            CommentPassword: commentPassword


        }, function (cmtData) {
            if (cmtData.status == 'success') {

                Swal.fire(
                    '등록완료!',
                    '댓글이 등록 되었습니다.',
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
                    title: '등록 실패 입니다',
                    text: cmtData.message,
                })
                //$('.swal2-confirm').click((e) => {
                //    e.prevantDefault();

                //});
            }
        }

        );

    }


}); // level 1이상 commentAdd end








// 공백 validation 확인
function noWhiteSpace(content) {
    var v = $(content).val().trim();

    if (v.length == 0) {
        $(content).val('');
        //$(content).focus();
        $(content).next().removeClass('b-invisible');
    } else {
        $(content).next().addClass('b-invisible');
        return true;
    }
}

function checkLength(content) {
    var pLength = $(content).val().length;
    if (pLength <= 4) {
        $(content).next().removeClass('b-invisible');
    } else {
        $(content).next().addClass('b-invisible');
        return true;
    }
}

// 입력 시 validation check label 안보이게
$(document).ready(function () {
    $('input, textarea').keydown(function () {
        $(this).next().addClass('b-invisible');
    });


});

// html 인코딩
function htmlEncode(content) {

    content = content.replace(/</g, "&lt;");
    content = content.replace(/>/g, "&gt;");
    content = content.replace(/\"/g, "&quot;");
    content = content.replace(/\'/g, "&#39;");
    content = content.replace(/\n/g, "<br />");

    return content;
}

function htmlDecode(content) {

    content = content.replace(/&lt;/g, "<");
    content = content.replace(/&gt;/g, ">");
    content = content.replace(/&quot;/g, "\"");
    content = content.replace(/&#39;/g, "\'"); 
    content = content.replace(/<br \/ >/g, "\n");

    return content;
}


//$(function () {
//    $('#comment-inputContent').keyup(function () {
//        byteHandler(this);
//    });
//});

//function byteHandler(obj) {
//    var contentText = $(obj).val();
//    $('.comment-bytes').text(getTextLength(contentText));
//}

//function getTextLength(str) {
//    var len = 0;

//    for (var i = 0; i < str.length; i++) {
//        if (escape(str.charAt(i).length == 6)) {
//            len++;
//        }
//        len++;
//    }
//    return len;
//}