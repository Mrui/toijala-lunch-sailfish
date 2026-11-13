import QtQuick 2.0
import "." as Shared

Shared.RestaurantMenu {
    restaurantName: "Ravintola Leskirouva"
    menuUrl: "https://www.leskirouva.fi/lounas/"
    stopWords: "Lounaan hinta|Hinnat|Hinnad|Lounaspassi|Allergeenit|Aistaanek|Yhteystiedot|Seuraavat"
    shortDayNames: ["", "MA", "TI", "KE", "TO", "PE", ""]
}
