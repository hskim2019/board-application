﻿

// case(1) InputContent with textarea w/o file attachment
//$('#boardAdd-button').click((e) => {
//    e.preventDefault;

//    if (!$('#add-inputTitle').val() || $('#add-inputTitle').val().replace(/\s/g, "").length == 0) {
//        $('#add-inputTitle').val('');
//        $('#add-inputTitle').focus();
//        $('#titleLabel-add').addClass('warning');
//    } else if (!$('#add-inputWriter').val() || $('#add-inputWriter').val().replace(/\s/g, "").length == 0) {
//        $('#add-inputWriter').val('');
//        $('#add-inputWriter').focus();

//    } else if (!$('#add-inputContent').val() || $('#add-inputContent').val().replace(/\s/g, "").length == 0) {
//    $('#add-inputContent').val('');
//    $('#add-inputContent').focus();
//}


//    else {

//        //var before = $('#add-inputContent').val();

//        //before = before.replace(/</g, "&lt;");
//        //before = before.replace(/>/g, "&gt;");
//        //bofore = before.replace(/\"/g, "&quot;");
//        //before = before.replace(/\'/g, "&#39;");
//        //before = before.replace(/\n/g, "<br />");

//        //var BoardContent = before;
//        //alert(BoardContent);




//        Swal.fire({
//            title: '게시글을 등록하시겠습니까?',
//            text: "",
//            icon: 'question',
//            showCancelButton: true,
//            cancelButtonColor: '#d33',
//            confirmButtonColor: '#3085d6',
//            cancelButtonText: '취소',
//            confirmButtonText: '확인'
//        }).then((result) => {

//            if (result.value) {


//                $.post('/Board/Add', {

//                    BoardTitle: $('#add-inputTitle').val(),
//                    BoardWriter: $('#add-inputWriter').val(),
//                    BoardContent: $('#add-inputContent').val()


//                },
//                    function (data) {
//                        if (data.status == 'success') {
//                            //alert('data.boardNo' + data.boardNo);

//                            Swal.fire(
//                                '등록완료!',
//                                '게시글이 등록 되었습니다.',
//                                'success'
//                            )
//                            $('.swal2-confirm').click((e) => {
//                                e.preventDefault();
//                                location.href = "Detail?boardNo=" + data.boardNo;
//                            });




//                        } else {
//                            //alert('등록 실패 입니다\n' + data.message);

//                            Swal.fire({
//                                type: 'error',
//                                title: '등록 실패 입니다',
//                                text: data.message,
//                            })
//                            $('.swal2-confirm').click((e) => {
//                                e.preventDefault();
//                                location.href = "index";
//                            });


//                        }
//                    }
//                );
//            }//end result.value

//        });
//    }

//});




// case(2) InputContent with WYSIWYG w/ Single File attachment
//$('#boardAdd-button').click((e) => {
//    e.preventDefault;
//    //alert($('#add-inputContent').val().replace(/&nbsp;/g, "").replace(/\s/g, "").length);
//    //alert($('#add-inputContent').val().replace(/<br>/g, "").replace(/<p>/g, "").replace(/<\/p>/g, ""));
//    if (!$('#add-inputTitle').val() || $('#add-inputTitle').val().replace(/\s/g, "").length == 0) {
//        $('#add-inputTitle').val('');
//        $('#add-inputTitle').focus();
//        $('#titleLabel-add').addClass('warning');
//    } else if (!$('#add-inputWriter').val() || $('#add-inputWriter').val().replace(/\s/g, "").length == 0) {
//        $('#add-inputWriter').val('');
//        $('#add-inputWriter').focus();

//    }

//    //else if (!$('#add-inputContent').val() || $('#add-inputContent').val().replace(/\s/g, "").length == 0) {
//    //    $('#add-inputContent').val('');
//    //    $('#add-inputContent').focus();
//    //}

//    else if (!$('#add-inputContent').val() ||
//        $('#add-inputContent').val().replace(/\&nbsp;/g, "").replace(/\s/g, "") == '<p></p>'||
//        $('#add-inputContent').val().replace(/&nbsp;/g, "").replace(/\s/g, "").replace(/<br>/g, "").replace(/<p>/g, "").replace(/<\/p>/g, "").length == 0) {
//        $('.editor').summernote('code', '');
//        $('.note-editable').focus();
//    }


//    else {


//        if ($('img')) {
//            var img = $('img');

//            var width = img.outerWidth();
//            var height = img.outerHeight();
//            if (width >= 608) {
//                img.css("width", "608");
//                var ratio = 608 / width;
//                var newHeight = height * ratio;
//                img.css("height", newHeight);
//              //  alert(newHeight);

//            }


//        }



//        var form = $('#board-add-form')[0];
//        var formData = new FormData(form);
//        formData.append("BoardTitle", $('#add-inputTitle').val());
//        formData.append("BoardWriter", $('#add-inputWriter').val());
//        formData.append("BoardContent", $('#add-inputContent').val());
//        formData.append("uploadFile", $('#add-inputFile')[0].files[0]);

//        console.log($('#add-inputFile')[0].files[0]);

//        Swal.fire({
//            title: '게시글을 등록하시겠습니까?',
//            text: "",
//            icon: 'question',
//            showCancelButton: true,
//            cancelButtonColor: '#d33',
//            confirmButtonColor: '#3085d6',
//            cancelButtonText: '취소',
//            confirmButtonText: '확인'
//        }).then((result) => {

//            if (result.value) {


//                $.ajax({
//                    url: '/Board/Add',
//                    processData: false,
//                    contentType: false,
//                    data: formData,
//                    type: 'POST',
//                    success: function (result) {

//                        if (result.status == 'success') {
//                            //alert('data.boardNo' + data.boardNo);

//                            Swal.fire(
//                                '등록완료!',
//                                '게시글이 등록 되었습니다.',
//                                'success'
//                            )
//                            $('.swal2-confirm').click((e) => {
//                                e.preventDefault();

//                                sessionStorage.removeItem('pageScale');
//                                sessionStorage.removeItem('curPage');
//                                sessionStorage.removeItem('pageSize-text');

//                                location.href = "Detail?boardNo=" + result.boardNo;
//                            });




//                        } else {
//                            //alert('등록 실패 입니다\n' + data.message);

//                            Swal.fire({
//                                type: 'error',
//                                title: '등록 실패 입니다',
//                                text: result.message,
//                            })
//                            $('.swal2-confirm').click((e) => {
//                                e.preventDefault();
//                                location.href = "index";
//                            });


//                        }
//                    }
//                }); //ajax end





//            }//end result.value

//        });
//    }

//});


// case (3) InputContent with WYSIWYG w/ Multiple File attachment
$('#boardAdd-button').click((e) => {
    e.preventDefault;
    //alert($('#add-inputContent').val().replace(/&nbsp;/g, "").replace(/\s/g, "").length);
    //alert($('#add-inputContent').val().replace(/<br>/g, "").replace(/<p>/g, "").replace(/<\/p>/g, ""));
    if (!$('#add-inputTitle').val() || $('#add-inputTitle').val().replace(/\s/g, "").length == 0) {
        $('#add-inputTitle').val('');
        $('#add-inputTitle').focus();
        $('#titleLabel-add').addClass('warning');
    } else if (!$('#add-inputWriter').val() || $('#add-inputWriter').val().replace(/\s/g, "").length == 0) {
        $('#add-inputWriter').val('');
        $('#add-inputWriter').focus();

    }

    //else if (!$('#add-inputContent').val() || $('#add-inputContent').val().replace(/\s/g, "").length == 0) {
    //    $('#add-inputContent').val('');
    //    $('#add-inputContent').focus();
    //}

    else if (!$('#add-inputContent').val() ||
        $('#add-inputContent').val().replace(/\&nbsp;/g, "").replace(/\s/g, "") == '<p></p>' ||
        $('#add-inputContent').val().replace(/&nbsp;/g, "").replace(/\s/g, "").replace(/<br>/g, "").replace(/<p>/g, "").replace(/<\/p>/g, "").length == 0) {
        $('.editor').summernote('code', '');
        $('.note-editable').focus();
    }


    else {


        if ($('img')) {
            var img = $('img');

            var width = img.outerWidth();
            var height = img.outerHeight();
            if (width >= 608) {
                img.css("width", "608");
                var ratio = 608 / width;
                var newHeight = height * ratio;
                img.css("height", newHeight);
                //  alert(newHeight);

            }


        }



        var form = $('#board-add-form')[0];
        var formData = new FormData(form);
        formData.append("BoardTitle", $('#add-inputTitle').val());
        formData.append("BoardWriter", $('#add-inputWriter').val());
        formData.append("BoardContent", $('#add-inputContent').val());

        //console.log($('#add-inputFile')[0].files.length);
        //console.log($("#add-inputFile").val());
        //console.log(fileTempArr);
        //console.log($('#add-inputFile')[0].files);

        //for (var i = 0; i < $('#add-inputFile')[0].files.length; i++) {

        //formData.append("uploadFile", $('#add-inputFile')[0].files[i]);
        //}

        for (var i = 0; i < fileTempArr.length; i++) {

            formData.append("uploadFile", fileTempArr[i]);
        }



        Swal.fire({
            title: '게시글을 등록하시겠습니까?',
            text: "",
            icon: 'question',
            showCancelButton: true,
            cancelButtonColor: '#d33',
            confirmButtonColor: '#3085d6',
            cancelButtonText: '취소',
            confirmButtonText: '확인'
        }).then((result) => {

            if (result.value) {


                $.ajax({
                    url: '/Board/Add',
                    processData: false,
                    contentType: false,
                    data: formData,
                    type: 'POST',
                    success: function (result) {

                        if (result.status == 'success') {
                            //alert('data.boardNo' + data.boardNo);

                            Swal.fire(
                                '등록완료!',
                                '게시글이 등록 되었습니다.',
                                'success'
                            )
                            $('.swal2-confirm').click((e) => {
                                e.preventDefault();

                                sessionStorage.removeItem('pageScale');
                                sessionStorage.removeItem('curPage');
                                sessionStorage.removeItem('pageSize-text');

                                location.href = "Detail?boardNo=" + result.boardNo;
                            });




                        } else {
                            //alert('등록 실패 입니다\n' + data.message);

                            Swal.fire({
                                type: 'error',
                                title: '등록 실패 입니다',
                                text: result.message,
                            })
                            $('.swal2-confirm').click((e) => {
                                e.preventDefault();
                                location.href = "index";
                            });


                        }
                    }
                }); //ajax end





            }//end result.value

        });
    }

});






//$(document).ready(function () {
//    var fileTarget = $('.filebox .upload-hidden');

//    fileTarget.on('change', function () {

//        if (fileSizeCheck($(this)[0])) {

//        // 값이 변경되면
//        if (window.FileReader) { // modern browser 
//            var filename = $(this)[0].files[0].name;
//        } else { // old IE var 
//            filename = $(this).val().split('/').pop().split('\\').pop(); // 파일명만 추출 
//        }


//        // 추출한 파일명 삽입 
//        $(this).siblings('.upload-name').val(filename);
//        }

//    });

//    $('.editor').summernote({
//        placeholder: '내용을 입력하세요.',
//        height: 300,                 // set editor height
//        minHeight: null,             // set minimum height of editor
//        maxHeight: null,             // set maximum height of editor
//       // focus: true,  
//        lang: 'ko-KR',
//        toolbar: [
//            // [groupName, [list of button]]
//            ['font', ['bold', 'italic', 'underline', 'clear']],
//            ['fontface', ['fontname']],
//            ['fontsize', ['fontsize']],
//            ['color', ['color']],
//            ['para', ['ul', 'ol', 'paragraph']],
//            ['height', ['height']],
//            ['table', ['table']],
//            ['insert', ['link', 'picture', 'video']]

//        ]

//    });



//});




$(document).ready(function () {
    var fileTarget = $('.filebox .upload-hidden');

    fileTarget.on('change', addFiles);

    $('.editor').summernote({
        placeholder: '내용을 입력하세요.',
        height: 300,                 // set editor height
        minHeight: null,             // set minimum height of editor
        maxHeight: null,             // set maximum height of editor
        // focus: true,  
        lang: 'ko-KR',
        toolbar: [
            // [groupName, [list of button]]
            ['font', ['bold', 'italic', 'underline', 'clear']],
            ['fontface', ['fontname']],
            ['fontsize', ['fontsize']],
            ['color', ['color']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['height', ['height']],
            ['table', ['table']],
            ['insert', ['link', 'picture', 'video']]

        ]

    });




});



// Multiple File Attachment - File name preview
var fileTempArr = [];

function addFiles(e) {


    var files = e.target.files;

    var fileArr = Array.prototype.slice.call(files);
    //console.log(fileArr.length);
    //console.log(fileArr[0].size);


    var fileArrayLength = fileArr.length;  // temporarly
    var fileTempArrayLength = fileTempArr.length; 
    console.log("temparray:" + fileTempArrayLength + "  currentattachedArrLength: " + fileArrayLength);

    if (fileTempArrayLength >= 5 || fileTempArrayLength + fileArrayLength >= 6) {

        Swal.fire({
            icon: 'error',
            title: '파일 첨부 실패',
            text: '파일 첨부는 최대 5개까지 가능합니다'
        })
    } else {
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



}






//$('#add-inputFileCancel').click((e) => {
//    e.preventDefault();

//    $("#add-inputFile").val("");



//    var defaultValue = "첨부파일 사이즈는 5MB 이내로 등록 가능합니다";
//    $('.upload-name').val(defaultValue);
//});



function fileSizeCheck(file) {
    var maxSize = 5 * 1024 * 1024;  // max 5MB
    var fileSize = 0;

    // Check Browser
    var browser = navigator.appName;

    // in case Internet Explorer
    if (browser == "Microsoft Internet Explorer") {
        var oas = new ActiveXObject("Scripting.FileSystemObject");
        fileSize = oas.getFile(file.value).size;
    }
    // Other Browsers
    else {
        // Single File Attachment
        //fileSize = file.files[0].size;

        // Multiple File Attachment
        fileSize = file.size;
    }


    //alert("파일사이즈 : " + fileSize + ", 최대파일사이즈 : 5MB");

    if (fileSize > maxSize) {
        alert("첨부파일 사이즈는 5MB 이내로 등록 가능합니다.\n" + file.name + " 의 용량이 5MB 이상입니다.");
        return;
    } else {
        return true;
    }

}



// DeteteFile in Cleint side
function deleteFile(eventParam, orderParam) {
    eventParam.preventDefault();

    fileTempArr.splice(orderParam, 1); // splice(start, count)
   // console.log(fileTempArr.length);
    var innerHtmlTemp = '';
    var fileTempArrayLength = fileTempArr.length;
    for (var i = 0; i < fileTempArrayLength; i++) {
        innerHtmlTemp += "<div class='panel panel-default'><div class='panel-body'>" + fileTempArr[i].name +
            "<a href='javascript:void(0)' class='glyphicon glyphicon-remove-circle' id='fileDelete' aria-hidden='true' data='"
            + (fileTempArrayLength + i) + "' style='float:right' onclick='deleteFile(event, " + i + ");'></a></div></div>";
    }
    $('#fileList').html(innerHtmlTemp);
}