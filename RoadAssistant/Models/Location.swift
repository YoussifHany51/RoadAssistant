//
//  Location.swift
//  RoadAssistant
//
//  Created by Youssif Hany on 25/02/2022.
//

import Foundation
import MapKit

struct Location: Identifiable , Equatable {
        
    let id = UUID().uuidString
    let roadName : String
    let cityName : String
    let coordinates : CLLocationCoordinate2D
    let description : String
    let imageName : [String]
    
//    var id: String {
//        roadName + cityName
//    }
    
    //Equatable
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
    
}
