// In der wwwroot/js/custom.js Datei

(function () {
    'use strict';

    // Prüft, ob die Funktion bereits definiert ist, um Konflikte zu vermeiden
    if (typeof window.saveAsFile !== 'function') {
        window.saveAsSpreadSheet = function (fileName, content) {
            try {
                const blob = new Blob([base64ToArrayBuffer(content)], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });
                const link = document.createElement('a');

                // Verwende createObjectURL nur, wenn es verfügbar ist (für ältere Browser)
                if ('createObjectURL' in URL) {
                    link.href = URL.createObjectURL(blob);
                } else {
                    link.href = 'data:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;base64,' + content;
                }

                link.download = fileName;
                document.body.appendChild(link);
                link.click();
            } catch (error) {
                //console.error('Error in saveAsFile:', error);
            } finally {
                document.body.removeChild(link);
            }
        };
    }

    function base64ToArrayBuffer(base64) {
        const binaryString = window.atob(base64);
        const len = binaryString.length;
        const bytes = new Uint8Array(len);
        for (let i = 0; i < len; i++) {
            bytes[i] = binaryString.charCodeAt(i);
        }
        return bytes.buffer;
    }
})();

// In der wwwroot/js/custom.js Datei

window.exportToTxt = function (fileName, content) {
    try {
        // Überprüfe, ob der Link bereits existiert, und entferne ihn gegebenenfalls
        const existingLink = document.getElementById('exportLink');
        if (existingLink) {
            document.body.removeChild(existingLink);
        }

        const blob = new Blob([content], { type: 'text/plain' });
        const link = document.createElement('a');
        link.id = 'exportLink';

        // Verwende createObjectURL nur, wenn es verfügbar ist (für ältere Browser)
        if ('createObjectURL' in URL) {
            link.href = URL.createObjectURL(blob);
        } else {
            link.href = 'data:text/plain;charset=utf-8,' + encodeURIComponent(content);
        }

        link.download = fileName;
        document.body.appendChild(link);
        link.click();
    } catch (error) {
        //console.error('Error in exportToTxt:', error);
    }
};

// Auto scrolling textbox
function scrollToEnd(textarea) {
    textarea.scrollTop = textarea.scrollHeight;
}

