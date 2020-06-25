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


const accountName = "studygroupblob";
const sasString = 'BlobEndpoint=https://studygroupblob.blob.core.windows.net/;QueueEndpoint=https://studygroupblob.queue.core.windows.net/;FileEndpoint=https://studygroupblob.file.core.windows.net/;TableEndpoint=https://studygroupblob.table.core.windows.net/;SharedAccessSignature=sv=2019-10-10&ss=bfqt&srt=sco&sp=rwdlacupx&se=2020-06-25T16:49:23Z&st=2020-06-25T08:49:23Z&spr=https&sig=4E6syaw%2BZO5Rto6mTBT69ua4cAOTXujSgfYIxZxvzPE%3D';
const containerName = "testcontainer";
const containerURL = new azblob.ContainerURL(
    `https://${accountName}.blob.core.windows.net/${containerName}?${sasString}`,
    azblob.StorageURL.newPipeline(new azblob.AnonymousCredential));

function listAzureStorageContainer() {
    $.ajax({
        url: uri,
        type: "PUT",
        data: requestData,
        processData: false,
        beforeSend: function (xhr) {
            xhr.setRequestHeader('x-ms-blob-type', 'BlockBlob');
            xhr.setRequestHeader('Content-Length', requestData.length);
        },
        success: function (data, status) {
            console.log(data);
            console.log(status);
            bytesUploaded += requestData.length;
            var percentComplete = ((parseFloat(bytesUploaded) / parseFloat(selectedFile.size)) * 100).toFixed(2);
            $("#fileUploadProgress").text(percentComplete + " %");
            uploadFileInBlocks();
        },
        error: function (xhr, desc, err) {
            console.log(desc);
            console.log(err);
        }
    });
    

}