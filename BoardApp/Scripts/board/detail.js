var param = location.href.split('?')[1],
    boardNo = param.split('=')[1];

//$(document).on('click', '#detail-returnToIndex', function () {
//    event.preventDefault();
//    history.go(-1);
//    //boardList(1);
//});

$(document).ready(function () {

    if ($('img')) {
        var img = $('img');
        
        var width = img.outerWidth();
        if (width >= 608) {
            img.css("width", "608");
        }

    }

    listAzureStorageContainer();

});

function listAzureStorageContainer() {

var key = "dPpMoJXWwJhSn4C82u65NAMRxwQ2E2tceiMRozf58NPFsKPgecX3CoOtGE/2yh5T5ixZBfn8j6Lfrxu+vj8GYw==";
var strTime = (new Date()).toUTCString();
var strToSign = 'GET\n\n\n\n\n\n\n\n\n\n\n\nx-ms-date:' + strTime + '\nx-ms-version:2015-12-11\n/studygroupblob/\ncomp:list';
var secret = CryptoJS.enc.Base64.parse(key);
var hash = CryptoJS.HmacSHA256(strToSign, secret);
var hashInBase64 = CryptoJS.enc.Base64.stringify(hash);
var auth = "SharedKey studygroupblob:" + hashInBase64; 

    $.ajax({
        url: "https://studygroupblob.blob.core.windows.net/?comp=list",
        type: "GET",
        beforeSend: function (xhr) {
            xhr.setRequestHeader('Authorization', auth);
            xhr.setRequestHeader('x-ms-date', strTime);
            xhr.setRequestHeader('x-ms-version', '2015-12-11');
        },
        success: function (data, status){
            var t = data;

            for (var i = 0; data.getElementsByTagName("Name").length > i; i++) {

                var containerName = data.getElementsByTagName("Name")[i].innerHTML
                console.log(containerName);
            }
        },
        error: function (xhr, desc, err) {
            console.log(desc);
            console.log(err);
        }
    })

}


//$.ajax({
//    url: uri,
//    type: "PUT",
//    data: requestData,
//    processData: false,
//    beforeSend: function (xhr) {
//        xhr.setRequestHeader('x-ms-blob-type', 'BlockBlob');
//        xhr.setRequestHeader('Content-Length', requestData.length);
//    },
//    success: function (data, status) {
//        console.log(data);
//        console.log(status);
//        bytesUploaded += requestData.length;
//        var percentComplete = ((parseFloat(bytesUploaded) / parseFloat(selectedFile.size)) * 100).toFixed(2);
//        $("#fileUploadProgress").text(percentComplete + " %");
//        uploadFileInBlocks();
//    },
//    error: function (xhr, desc, err) {
//        console.log(desc);
//        console.log(err);
//    }
//});