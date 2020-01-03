// attachment update.js

var param = location.href.split('?')[1],
    boardNo = param.split('=')[1];


var attachmentBody = $('#fileList');

var originFile = [];
var originFileArraylength;

var fileTempArr = [];
var removedNo = [];
var fileTempArrayLength;

//Initial attachment list loading
function attachmentList(bno) {
    $.getJSON('/Attachment/Index?boardNo=' + bno,
        function (obj) {


            attachmentBody.html('');
         
            var a = '';
            
            $.each(obj.list, function (key, value) {

               // var fileArrayLength = obj.list.length; // initial attachment list length
               // fileTempArrayLength = fileTempArr.length; // variation for total array length
                //console.log(fileArrayLength);
                //console.log(fileTempArrayLength);

                var fileName = value.AttachmentPath.split('_')[1];

                originFile.push(value.AttachmentNo);
               originFileArraylength = originFile.length;
                //console.log(originFile);
                //console.log(originFileArraylength);

                $('#originFileList').append("<div class='panel panel-default'><div class='panel-body'>" + fileName +
                    "<a href='javascript:void(0)' class='glyphicon glyphicon-remove-circle' id='originFileDelete' aria-hidden='true' data='"
                    + originFileArraylength + "' data-no='" + value.AttachmentNo + "' style='float:right'></a></div></div>");

               
            });
            console.log("originFile: " + originFile);
            console.log("originFileArrayLength: " + originFileArraylength);
         
        })
}

// Load Initial attachment list
attachmentList(boardNo);


$(document).ready(function () {
    var fileTarget = $('.filebox .upload-hidden');
    fileTarget.on('change', addFiles);
});

function addFiles(e) {

    var files = e.target.files;
    //console.log(files);

    var fileArr = Array.prototype.slice.call(files);
    //console.log(fileArr);
    
    var fileArrayLength = fileArr.length;
    //console.log(fileArrayLength);
    var fileTempArrayLength = fileTempArr.length;
    //console.log(fileTempArrayLength);

    if (fileTempArrayLength + originFileArraylength >= 5 || fileTempArrayLength + fileArrayLength + originFileArraylength >= 6) {
        Swal.fire({
            icon: 'error',
            title: '파일 첨부 실패',
            text: '파일 첨부는 최대 5개까지 가능합니다'
        })
    } else {

  

    for (var i = 0; i < fileArrayLength; i++) {

        if (fileSizeCheck(fileArr[i])) {

            fileTempArr.push(fileArr[i]);
            $('#newFileList').append("<div class='panel panel-default'><div class='panel-body'>" + fileArr[i].name +
                "<a href='javascript:void(0)' class='glyphicon glyphicon-remove-circle' id='fileDelete' aria-hidden='true' data='"
                + (fileTempArrayLength + i) + "' style='float:right' onclick='deleteFile(event, " + (fileTempArrayLength + i) + ");'></a></div></div>");

        }


    }
    $(this).val('');

    }
}


//function originDeleteFile(eventParam, orderParam) {
$(document).on('click', '#originFileDelete', function () {

    var originAttachmentNo = $(this).attr('data-no');
    //alert(originAttachmentNo);
    removedNo.push(originAttachmentNo);
    originFile.pop(originAttachmentNo);
    var innerHtmlTemp = '';
    originFileArraylength = originFile.length;

    console.log("originFile: " + originFile);
    console.log("originFileArrayLength: " + originFileArraylength);

    if (originFileArraylength == 0) {

        $(this).parent().parent().parent().prev().remove();
        $(this).parent().parent().parent().remove();

    } else {

    $(this).parent().parent().remove();
    }




   // console.log(removedNo);
    //for (var i = 0; i < originFileArraylength; i++) {

    //}
});


// DeteteFile in Cleint side
function deleteFile(eventParam, orderParam) {
    eventParam.preventDefault();

    fileTempArr.splice(orderParam, 1); // splice(start, count)

    var innerHtmlTemp = '';
    var fileTempArrayLength = fileTempArr.length;
    for (var i = 0; i < fileTempArrayLength; i++) {
        innerHtmlTemp += "<div class='panel panel-default' id='attachment-panel'><div class='panel-body' id='attachment-panelBody'>" + fileTempArr[i].name +
            "<a href='javascript:void(0)' class='glyphicon glyphicon-remove-circle' id='fileDelete' aria-hidden='true' data='"
            + (fileTempArrayLength + i) + "' style='float:right' onclick='deleteFile(event, " + i + ");'></a></div></div>";
    }
    $('#newFileList').html(innerHtmlTemp);

}