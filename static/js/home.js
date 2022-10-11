function _documentOnLoad()
{
    console.log("_documentOnLoad");

    document.getElementById("uploadInput").addEventListener("change", function(e) {
        let file = e.target.files[0];
        let formData = new FormData();
        formData.append("file", file);
        httpPost("/file", formData, function(status, data) {
            console.log(status);
            console.log(data);
        });
    });
    wasmInit();
}

window.onresize = function() {
    console.log("window.onresize");
};

window.onload = function() {
    console.log("window.onload");
};
