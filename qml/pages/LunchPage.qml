import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: lunchPage

    property string paivanNimi: ""

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
                text: qsTr("Päivän Lounas")
                width: parent.width
                font.bold: true
                font.pixelSize: 48
                color: Theme.highlightColor
                wrapMode: Text.WordWrap
            }

            Label {
                width: parent.width
                text: paivanNimi
                font.pixelSize: 40
            }

            Loader {
                id: leskirouvaLoader
                width: parent.width
                source: "../restaurants/leskirouva.qml"
            }

            Item {
                width: 1
                height: Theme.paddingMedium
            }

            Loader {
                id: oskariLoader
                width: parent.width
                source: "../restaurants/oskari.qml"
            }

            Item {
                width: 1
                height: Theme.paddingMedium
            }

            Loader {
                id: alibabaLoader
                width: parent.width
                source: "../restaurants/alibaba.qml"
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

    Component.onCompleted: lunchPage.paivitaPaivanNimi()

    function paivitaPaivanNimi() {
        var paivat = ["Sunnuntai", "Maanantai", "Tiistai", "Keskiviikko", "Torstai", "Perjantai", "Lauantai"]
        paivanNimi = paivat[new Date().getDay()]
    }

    function haeLounas() {
        paivitaPaivanNimi()
        if (leskirouvaLoader.item) {
            leskirouvaLoader.item.refresh()
        }
        if (oskariLoader.item) {
            oskariLoader.item.refresh()
        }
        if (alibabaLoader.item) {
            alibabaLoader.item.refresh()
        }
    }
}
