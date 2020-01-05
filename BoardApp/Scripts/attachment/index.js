var attachmentBody = $('.attachment-view');

//var attachmentTemplateSrc = $('#attachment-template').html();
//var attachmentGenerator = Handlebars.compile(attachmentTemplateSrc);

 //attachment list loading
function attachmentList(bno) {
    $.getJSON('/Attachment/Index?boardNo=' + bno,
        function (obj) {


            $('.attachment-count').html('첨부파일 ' + obj.rowCount + '개');

            attachmentBody.html('');
           // $(attachmentGenerator(obj)).appendTo(attachmentBody);
            var a = '';
            $.each(obj.list, function (key, value) {

                var fileName = value.AttachmentPath.split('_')[1];

                a += "<div class='panel panel-default' id='attachment-panel'><div class='panel-body' id='attachment-panelBody'>"
                    + "<a href='/Attachment/Download?attachmentNo=" +value.AttachmentNo + "' class='fileName' data='" + value.AttachmentNo + "'>" + fileName
                    + "<span class='glyphicon glyphicon-save' aria-hidden='true' style='float:right'></span></a></div></div>";
                
            }); 
            $('.attachment-view').html(a);
        })
}

attachmentList(boardNo);
