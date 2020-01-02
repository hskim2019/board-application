var param = location.href.split('?')[1],
    boardNo = param.split('=')[1];


var attachmentBody = $('#fileList');

var files;
var fileArr;
var fileTempArr = [];
var fileTempNo = [];

//attachment list loading
function attachmentList(bno) {
    $.getJSON('/Attachment/Index?boardNo=' + bno,
        function (obj) {


            attachmentBody.html('');
            // $(attachmentGenerator(obj)).appendTo(attachmentBody);
            var a = '';
            
            $.each(obj.list, function (key, value) {

                var fileArrayLength = obj.list.length;
                var fileTempArrayLength = fileTempArr.length;
                //console.log(fileArrayLength);
                //console.log(fileTempArrayLength);

                var fileName = value.AttachmentPath.split('_')[1];
                fileTempNo.push(value.AttachmentNo);
                fileTempArr.push(fileName);

                $('#fileList').append("<div class='panel panel-default'><div class='panel-body'>" + fileName +
                    "<a href='javascript:void(0)' class='glyphicon glyphicon-remove-circle' id='fileDelete' aria-hidden='true' data='"
                    + (fileTempArrayLength) + "' style='float:right' onclick='deleteFile(event, " + (fileTempArrayLength)  + ");'></a></div></div>");

               
            });
            //console.log(fileTempNo);

            $('.attachment-view').html(a);
        })
}

attachmentList(boardNo);

$(document).ready(function () {
    var fileTarget = $('.filebox .upload-hidden');
    fileTarget.on('change', addFiles);
});

function addFiles(e) {


    var files = e.target.files;
    console.log(files);

    var fileArr = Array.prototype.slice.call(files);
    //console.log(fileArr);
    //console.log(fileArr[0].size);

    var fileArrayLength = fileArr.length;
    console.log(fileArrayLength);
    var fileTempArrayLength = fileTempArr.length;
    console.log(fileTempArrayLength);

    console.log(fileArr[0]);

    for (var i = 0; i < fileArrayLength; i++) {

        if (fileSizeCheck(fileArr[i])) {

            fileTempArr.push(fileArr[i]);
            $('#fileList').append("<div class='panel panel-default'><div class='panel-body'>" + fileArr[i].name +
                "<a href='javascript:void(0)' class='glyphicon glyphicon-remove-circle' id='fileDelete' aria-hidden='true' data='"
                + (fileTempArrayLength + i) + "' style='float:right' onclick='deleteFile(event, " + (fileTempArrayLength + i) + ");'></a></div></div>");

        }


    }
    $(this).val('');

}

