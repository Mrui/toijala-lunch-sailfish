import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: lunchPage

    property string paivanLounas: "Haetaan lounaslistaa..."
    readonly property string lounasUrl: "https://www.leskirouva.fi/lounas/"

    PageHeader {
        id: pageHeader
        title: qsTr("Toijala Lunch")
    }

    SilicaFlickable {
        id: menuFlickable
        anchors {
            top: pageHeader.bottom
            bottom: refreshButton.top
            left: parent.left
            right: parent.right
        }
        contentWidth: width
        contentHeight: contentColumn.height
        clip: true

        Column {
            id: contentColumn
            x: Theme.paddingLarge
            width: menuFlickable.width - 2 * Theme.paddingLarge
            spacing: Theme.paddingLarge

            Label {
                text: qsTr("Päivän lounas")
                width: parent.width
                font.bold: true
                font.pixelSize: 30
                color: Theme.highlightColor
                wrapMode: Text.WordWrap
            }

            Label {
                id: lounasTeksti
                width: parent.width
                text: paivanLounas
                wrapMode: Text.WordWrap
                font.pixelSize: 26
            }
        }
    }

    Button {
        id: refreshButton
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: Theme.paddingLarge
        }
        text: qsTr("Päivitä")
        onClicked: lunchPage.haeLounas()
    }

    Component.onCompleted: lunchPage.haeLounas()

    function haeLounas() {
        paivanLounas = "Haetaan..."
        var xhr = new XMLHttpRequest()
        xhr.open("GET", lounasUrl)

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    lunchPage.paivanLounas = lunchPage.parsiTamaPaiva(xhr.responseText)
                } else {
                    lunchPage.paivanLounas = "Virhe sivun latauksessa (Status: " + xhr.status + ")"
                }
            }
        }
        xhr.send()
    }

    function parsiTamaPaiva(html) {
        var paivat = ["Sunnuntai", "Maanantai", "Tiistai", "Keskiviikko", "Torstai", "Perjantai", "Lauantai"]
        var lyhina = ["PE", "MA", "TI", "KE", "TO", "PE", "PE"]
        var d = new Date()
        var tanaanIndex = d.getDay()

        if (tanaanIndex === 0 || tanaanIndex === 6) {
            return "Ei lounasta (viikonloppu)."
        }

        var puhdasTeksti = siivittaTekstin(html)
        var loppuus = "Lounaan hinta|Hinnat|Hinnad|Lounaspassi|Allergeenit|Aistaanek|Yhteystiedot|Seuraavat"

        var block = poimijadinihall(puhdasTeksti, paivat[tanaanIndex], loppuus)
        if (block === "") {
            block = poimijadinihall(puhdasTeksti, lyhina[tanaanIndex], loppuus)
        }

        var siivottuLounas = block.trim()
        if (siivottuLounas.length < 15) {
            return "Ei lounasta tänään (" + paivat[tanaanIndex] + ")."
        }
        return paivat[tanaanIndex] + ":\n\n" + siivottuLounas
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
        text = text.replace(/&#228;/g, "ä")
        text = text.replace(/&#196;/g, "Ä")
        text = text.replace(/&#246;/g, "ö")
        text = text.replace(/&#214;/g, "Ö")
        text = text.replace(/[ \t]+/g, " ")
        text = text.replace(/ ?\n ?/g, "\n")
        text = text.replace(/\n{3,}/g, "\n\n")
        return text
    }

    function poimijadinihall(text, dayToken, stopWords) {
        var startRe = new RegExp("(^|[^A-Za-z\u00c4\u00d6\u00dc\u00e4\u00f6\u00fc])" + dayToken + "([^A-Za-z\u00c4\u00d6\u00dc\u00e4\u00f6\u00fc]|$)")
        var osto = text.match(startRe)
        if (!osto) {
            return ""
        }

        var hilidomais = text.substring(osto.index + osto[0].length)
        var loppuRe = new RegExp("(^|[^A-Za-z])(MA|TI|KE|TO|PE)([^A-Za-z]|$)|(" + stopWords + ")")
        var loppu = hilidomais.match(loppuRe)
        return loppu ? hilidomais.substring(0, loppu.index) : hilidomais
    }
}
