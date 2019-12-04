$('#boardDelete-button').click((e) => {
    var boardNo = $('#boardDelete-button').attr('data-no');

    Swal.fire({
        title: '게시글을 삭제하시겠습니까?',
        text: "",
        icon: 'warning',
        showCancelButton: true,
        cancelButtonColor: '#d33',
        confirmButtonColor: '#3085d6',
        cancelButtonText: '취소',
        confirmButtonText: '확인'
    }).then((result) => {

        if (result.value) {
           
            $.getJSON('/Board/Delete?BoardNo=' + boardNo,
                function (data) {
                 
                    //alert(data.status);

                    if (data.status == 'success') {
                        Swal.fire(

                           '삭제완료!',
                           '해당 글을 삭제하였습니다.',
                           'success'
                        
                        )
                        $('.swal2-confirm').click((e) => {
                            e.preventDefault();
                            location.href = "Index";
                        });
                    } else {
                        //alert('삭제 실패 입니다.\n' + data.message);
                        Swal.fire({
                            icon: 'error',
                            title: '삭제 실패 입니다',
                            text: data.message,
                        })
                        $('.swal2-confirm').click((e) => {
                            e.preventDefault();
                            location.href = "Index";
                        });
                    }
                });

        }
    })
});