var commentReplyEditor = $('#comment-editor-template').html();

$(document).on("click", '.comment-replyBtn', function () {
    event.preventDefault();
    console.log($(this).parents('.comment-listRow'));
    $(this).parents('.comment-listRow').after(commentReplyEditor);
});