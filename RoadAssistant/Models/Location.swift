//
//  Location.swift
//  RoadAssistant
//
//  Created by Youssif Hany on 25/02/2022.
//

import Foundation
import MapKit

struct Defect: Identifiable , Equatable {
        
    let id = UUID().uuidString
    let roadName : String
    let cityName : String
    var coordinates : CLLocationCoordinate2D
    let imageName : [String]
    
//    var id: String {
//        roadName + cityName
//    }
    
    //Equatable
    static func == (lhs: Defect, rhs: Defect) -> Bool {
        lhs.id == rhs.id
    }
    
}
