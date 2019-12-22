
$('.editor').trumbowyg({

});


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





$('#boardAdd-button').click((e) => {
    e.preventDefault;

    if (!$('#add-inputTitle').val() || $('#add-inputTitle').val().replace(/\s/g, "").length == 0) {
        $('#add-inputTitle').val('');
        $('#add-inputTitle').focus();
        $('#titleLabel-add').addClass('warning');
    } else if (!$('#add-inputWriter').val() || $('#add-inputWriter').val().replace(/\s/g, "").length == 0) {
        $('#add-inputWriter').val('');
        $('#add-inputWriter').focus();

    } else if (!$('#add-inputContent').val() || $('#add-inputContent').val().replace(/\s/g, "").length == 0) {
        $('#add-inputContent').val('');
        $('#add-inputContent').focus();
    }



    else {


        var form = $('#board-add-form')[0];
        var formData = new FormData(form);
        formData.append("BoardTitle", $('#add-inputTitle').val());
        formData.append("BoardWriter", $('#add-inputWriter').val());
        formData.append("BoardContent", $('#add-inputContent').val());
        formData.append("uploadFile", $('#add-inputFile')[0].files[0]);

        console.log($('#add-inputFile')[0].files[0]);

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





$(document).ready(function () {
    var fileTarget = $('.filebox .upload-hidden');

    fileTarget.on('change', function () {

        if (fileSizeCheck($(this)[0])) {

        // 값이 변경되면
        if (window.FileReader) { // modern browser 
            var filename = $(this)[0].files[0].name;
        } else { // old IE var 
            filename = $(this).val().split('/').pop().split('\\').pop(); // 파일명만 추출 
        }


        // 추출한 파일명 삽입 
        $(this).siblings('.upload-name').val(filename);
        }

    });
});

$('#add-inputFileCancel').click((e) => {
    e.preventDefault();

    $("#add-inputFile").val("");



    var defaultValue = "첨부파일 사이즈는 5MB 이내로 등록 가능합니다";
    $('.upload-name').val(defaultValue);
});



function fileSizeCheck(file) {
    var maxSize = 5 * 1024 * 1000;
    //var maxSize = 5000;
    var fileSize = 0;

    // 브라우저 확인
    var browser = navigator.appName;

    // 익스플로러일 경우
    if (browser == "Microsoft Internet Explorer") {
        var oas = new ActiveXObject("Scripting.FileSystemObject");
        fileSize = oas.getFile(file.value).size;
    }
    // 익스플로러가 아닐경우
    else {
        fileSize = file.files[0].size;
    }


   // alert("파일사이즈 : " + fileSize + ", 최대파일사이즈 : 5MB");

    if (fileSize > maxSize) {
        alert("첨부파일 사이즈는 5MB 이내로 등록 가능합니다.    ");
        return;
    } else {
        return true;
    }

}


