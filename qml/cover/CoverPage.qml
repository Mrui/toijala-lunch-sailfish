import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    id: coverPage

    property string weekday: ""

    Column {
        anchors.centerIn: parent
        width: parent.width - 2 * Theme.paddingLarge
        spacing: Theme.paddingSmall

        Label {
            width: parent.width
            text: qsTr("Toijala Lunch")
            font.pixelSize: Theme.fontSizeLarge
            color: Theme.highlightColor
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }

        Label {
            width: parent.width
            text: coverPage.weekday
            font.pixelSize: Theme.fontSizeMedium
            horizontalAlignment: Text.AlignHCenter
        }
    }

    Timer {
        interval: 60000
        repeat: true
        running: true
        onTriggered: coverPage.updateWeekday()
    }

    Component.onCompleted: coverPage.updateWeekday()

    function updateWeekday() {
        var days = ["Sunnuntai", "Maanantai", "Tiistai", "Keskiviikko", "Torstai", "Perjantai", "Lauantai"]
        weekday = days[new Date().getDay()]
    }
}
