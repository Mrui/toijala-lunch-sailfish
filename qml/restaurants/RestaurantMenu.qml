import QtQuick 2.0
import Sailfish.Silica 1.0

Column {
    id: restaurantMenu

    property string restaurantName
    property string menuUrl
    property string stopWords
    property var shortDayNames: []
    property var dayNames: ["Sunnuntai", "Maanantai", "Tiistai", "Keskiviikko", "Torstai", "Perjantai", "Lauantai"]
    property bool splitBulletItems: false
    property string menuText: "Haetaan lounaslistaa..."

    width: parent ? parent.width : implicitWidth
    spacing: Theme.paddingSmall

    Label {
        width: parent.width
        text: restaurantMenu.restaurantName + " <a href=\"" + restaurantMenu.menuUrl + "\">link</a>"
        textFormat: Text.RichText
        wrapMode: Text.WordWrap
        font.bold: true
        font.pixelSize: 45
        color: Theme.highlightColor
        onLinkActivated: Qt.openUrlExternally(link)
    }

    Label {
        width: parent.width
        text: restaurantMenu.menuText
        wrapMode: Text.WordWrap
        font.pixelSize: 39
    }

    Component.onCompleted: restaurantMenu.refresh()

    function refresh() {
        var tanaanIndex = new Date().getDay()
        if (tanaanIndex === 0 || tanaanIndex === 6) {
            menuText = "Ei lounasta viikonloppuna."
            return
        }

        menuText = "Haetaan lounaslistaa..."
        var paiva = dayNames[tanaanIndex]
        var lyhenne = shortDayNames.length > tanaanIndex ? shortDayNames[tanaanIndex] : ""
        haeSivu(function (html) {
            restaurantMenu.menuText = restaurantMenu.parsiPaivanLounaan(html,
                                                                        paiva,
                                                                        lyhenne)
        }, function (status) {
            restaurantMenu.menuText = "Virhe lounaslistan latauksessa (Status: " + status + ")"
        })
    }

    function haeSivu(onSuccess, onError) {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", menuUrl)

        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    onSuccess(xhr.responseText)
                } else {
                    onError(xhr.status)
                }
            }
        }
        xhr.send()
    }

    function parsiPaivanLounaan(html, paiva, lyhenne) {
        var puhdasTeksti = siivittaTekstin(html)
        var block = poimijadinihall(puhdasTeksti, paiva)
        if (block === "" && lyhenne !== "") {
            block = poimijadinihall(puhdasTeksti, lyhenne)
        }

        var siivottuLounas = block.trim()
        if (splitBulletItems) {
            siivottuLounas = siivottuLounas.replace(/\s*•\s*/g, "\n")
        }
        siivottuLounas = siivottuLounas.replace(/\n{2,}/g, "\n")
        return siivottuLounas.length < 15 ? "Lounaslistaa ei löytynyt." : siivottuLounas
    }

    function siivittaTekstin(html) {
        var text = html.replace(/<br\s*\/?>/gi, "\n")
        text = text.replace(/<\/(p|div|li|tr|td|th|h[1-6])\s*>/gi, "\n")
        text = text.replace(/<script[\s\S]*?<\/script>/gi, " ")
        text = text.replace(/<style[\s\S]*?<\/style>/gi, " ")
        text = text.replace(/<[^>]+>/g, " ")
        text = text.replace(/&nbsp;/g, " ")
        text = text.replace(/&amp;/g, "&")
        text = text.replace(/&auml;/g, "ä")
        text = text.replace(/&Auml;/g, "Ä")
        text = text.replace(/&ouml;/g, "ö")
        text = text.replace(/&Ouml;/g, "Ö")
        text = text.replace(/&szlig;/g, "ß")
        text = text.replace(/&bull;|&#8226;/g, "•")
        text = text.replace(/&#228;/g, "ä")
        text = text.replace(/&#196;/g, "Ä")
        text = text.replace(/&#246;/g, "ö")
        text = text.replace(/&#214;/g, "Ö")
        text = text.replace(/[ \t]+/g, " ")
        text = text.replace(/ ?\n ?/g, "\n")
        text = text.replace(/\n{3,}/g, "\n\n")
        return text
    }

    function poimijadinihall(text, dayToken) {
        var startRe = new RegExp("(^|[^A-Za-z\u00c4\u00d6\u00dc\u00e4\u00f6\u00fc])" + dayToken
                                 + "([^A-Za-z\u00c4\u00d6\u00dc\u00e4\u00f6\u00fc]|$)")
        var osto = text.match(startRe)
        if (!osto) {
            return ""
        }

        var hilidomais = text.substring(osto.index + osto[0].length)
        var loppuRe = new RegExp("(^|[^A-Za-z])(MA|TI|KE|TO|PE)([^A-Za-z]|$)|("
                                 + restaurantMenu.stopWords + ")")
        var loppu = hilidomais.match(loppuRe)
        return loppu ? hilidomais.substring(0, loppu.index) : hilidomais
    }
}
