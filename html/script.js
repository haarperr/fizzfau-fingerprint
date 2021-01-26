


Fingerprint = {}

Fingerprint.Open = function() {
    $(".fingerprint-container").fadeIn(150);
    $(".fingerprint-id").html("Fingerprint ID<p>DNA Kod Dizilimi</p>");
}

Fingerprint.Close = function() {
    $(".fingerprint-container").fadeOut(150);
    $.post('http://fizzfau-fingerprint/closeFingerprint');
}

Fingerprint.Update = function(data) {
    $(".fingerprint-id").html("Fingerprint ID<p>"+data.fingerprintId+"</p>");
}

$(document).on('click', '.take-fingerprint', function(){
    $.post('http://fizzfau-fingerprint/doFingerScan');
})

document.onreadystatechange = () => {
    if (document.readyState === "complete") {
        window.addEventListener('message', function(event) {
            if (event.data.type == "fingerprintOpen") {
                Fingerprint.Open();
            } else if (event.data.type == "fingerprintClose") {
                Fingerprint.Close();
            } else if (event.data.type == "updateFingerprintId") {
                Fingerprint.Update(event.data);
            }
        });
    };
};

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESC
            Fingerprint.Close();
            break;
    }
});