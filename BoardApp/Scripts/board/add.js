$('#boardAdd-button').click((e) => {
    e.preventDefault;

    if (!$('#add-inputTitle').val() || $('#add-inputTitle').val().replace(/\s/g, "").length == 0) {
        $('#add-inputTitle').focus();
        $('#titleLabel-add').addClass('warning');
    } else if (!$('#add-inputWriter').val() || $('#add-inputWriter').val().replace(/\s/g, "").length == 0) {
        $('#add-inputWriter').focus();

    }


    else {

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


                $.post('/Board/Add', {

                    BoardTitle: $('#add-inputTitle').val(),
                    BoardWriter: $('#add-inputWriter').val(),
                    BoardContent: $('#add-inputContent').val()

                },
                    function (data) {
                        if (data.status == 'success') {
                            //alert('data.boardNo' + data.boardNo);

                            Swal.fire(
                                '등록완료!',
                                '게시글이 등록 되었습니다.',
                                'success'
                            )
                            $('.swal2-confirm').click((e) => {
                                e.preventDefault();
                                location.href = "Detail?boardNo=" + data.boardNo;
                            });




                        } else {
                            //alert('등록 실패 입니다\n' + data.message);

                            Swal.fire({
                                type: 'error',
                                title: '등록 실패 입니다',
                                text: data.message,
                            })
                            $('.swal2-confirm').click((e) => {
                                e.preventDefault();
                                location.href = "index";
                            });


                        }
                    }
                );
            }//end result.value

        });
    }

});


//$(document).ready(function () {
//    $('.registerForm').bootstrapValidator({
//        message: 'This value is not valid',
//        feedbackIcons: {
//            valid: 'glyphicon glyphicon-ok',
//            invalid: 'glyphicon glyphicon-remove',
//            validating: 'glyphicon glyphicon-refresh'
//        },
//        fields: {
//            username: {
//                message: 'The username is not valid',
//                validators: {
//                    notEmpty: {
//                        message: 'The username is required and cannot be empty'
//                    },
//                    stringLength: {
//                        min: 6,
//                        max: 30,
//                        message: 'The username must be more than 6 and less than 30 characters long'
//                    },
//                    regexp: {
//                        regexp: /^[a-zA-Z0-9_]+$/,
//                        message: 'The username can only consist of alphabetical, number and underscore'
//                    }
//                }
//            },
//            email: {
//                validators: {
//                    notEmpty: {
//                        message: 'The email is required and cannot be empty'
//                    },
//                    emailAddress: {
//                        message: 'The input is not a valid email address'
//                    }
//                }
//            }
//        }
//    });
//});