//
//  SearchVM.swift
//
//
//  Created by i-Verve on 20/04/21.
//

import UIKit
import GooglePlaces

class SearchVM: NSObject {
    
    let cancel = "Cancel"
    let empty = ""
    let popularSearches = "Popular Searches"
    let locations = "Locations"
    let venuesTitle = "Venues"
    
    var searchedText: String = ""
    var fetcher: GMSAutocompleteFetcher!, placesClient: GMSPlacesClient!
    var venues: [General] = [], places: [GMSAutocompletePrediction] = []
    
    func getData(indexPath: IndexPath) -> SearchTableVM {
        var text = empty
        if indexPath.section == 0 {
            if searchedText.isEmpty {
            }
            else {
                text = places.count > 0 ? places[indexPath.row].attributedFullText.string : "No Result Found"
            }
        }
        else {
            text = venues.count > 0 ? venues[indexPath.row].title : "Messages.noVenues"
        }
        return SearchTableVM.init(text: text)
    }
}
