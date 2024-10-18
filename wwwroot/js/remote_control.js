window.getBoundingClientRect = function (element) {
    if (element) {
        return element.getBoundingClientRect();
    }
    return null;
};

// JavaScript-Funktion zur Erfassung der Mausposition
function captureMousePosition(elementId) {
    var element = document.getElementById(elementId);
    element.addEventListener('click', function (event) {
        var rect = element.getBoundingClientRect();
        var x = event.clientX - rect.left;
        var y = event.clientY - rect.top;
        DotNet.invokeMethodAsync('YourAssemblyName', 'ProcessMouseClick', x, y);
    });
}
