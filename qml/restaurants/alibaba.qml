import QtQuick 2.0
import "." as Shared

Shared.RestaurantMenu {
    restaurantName: "Ravintola Alibaba"
    menuUrl: "https://www.ravintolaalibaba.fi/lounas"
    stopWords: "TIISTAI|KESKIVIIKKO|TORSTAI|PERJANTAI|Kaikki ruuat"
    dayNames: ["Sunnuntai", "MAANANTAI", "TIISTAI", "KESKIVIIKKO", "TORSTAI", "PERJANTAI", "Lauantai"]
    splitBulletItems: true
}
