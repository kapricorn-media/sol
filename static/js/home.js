function _documentOnLoad()
{
    console.log("_documentOnLoad");

    wasmInit();
}

window.onload = function() {
    console.log("window.onload");
};
