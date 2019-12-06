$('#updateBoard-button').click((e) => {
    e.preventDefault();

    if (!$('#add-inputTitle').val() || $('#add-inputTitle').val().replace(/\s/g, "").length == 0) {
        $('#add-inputTitle').val('');
        $('#add-inputTitle').focus();
        $('#titleLabel-add').addClass('warning');
    } else if (!$('#add-inputWriter').val() || $('#add-inputWriter').val().replace(/\s/g, "").length == 0) {
        $('#add-inputWriter').val('');
        $('#add-inputWriter').focus();

    } else if (!$('#add-inputContent').val() || $('#add-inputContent').val().replace(/\s/g, "").length == 0) {
        $('#add-inputContentr').val('');
        $('#add-inputContent').focus();
    }

    else {

        Swal.fire({
            title: '게시글을 수정 하시겠습니까?',
            text: "",
            icon: 'question',
            showCancelButton: true,
            cancelButtonColor: '#d33',
            confirmButtonColor: '#3085d6',
            cancelButtonText: '취소',
            confirmButtonText: '확인'
        }).then((result) => {

            if (result.value) {

            $.post('/Board/Update', {

                BoardNo: $('#updatedBoardNo').val(),
                BoardTitle: $('#add-inputTitle').val(),
                BoardWriter: $('#add-inputWriter').val(),
                BoardContent: $('#add-inputContent').val()

            },
                function (data) {
                    if (data.status == 'success') {
                        //alert('data.boardNo' + data.boardNo);

                        Swal.fire(
                            '등록완료!',
                            '게시글이 수정 되었습니다.',
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
                            title: '수정 실패 입니다',
                            text: data.message,
                        })
                        $('.swal2-confirm').click((e) => {
                            e.preventDefault();
                            location.href = "Index";
                        });


                    }
                }
            );

            } // result.value

        });
    }

});