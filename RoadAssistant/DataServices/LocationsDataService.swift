//
//  LocationsDataService.swift
//  RoadAssistant
//
//  Created by Youssif Hany on 25/02/2022.
//

import Foundation
import MapKit

class LocationsDataService {
    
    static let locations: [Location] = [
        
        Location(
            roadName: "26th july axis road",
            cityName: "6 October city",
            coordinates: CLLocationCoordinate2D(latitude:30.00908 , longitude:30.98528),
            //description: "Pothole in the middle of the road.",
            imageName: [
             "pothole1"
            ]
        ),
        
        Location(
            roadName: "Waslet Dahshur Road",
            cityName: "Sheikh Zayed City",
            coordinates: CLLocationCoordinate2D(latitude:30.01520 , longitude:30.97636),
           // description: "Pothole in the rigth side of the road.",
            imageName: [
             "pothole2"
            ]
        ),
        
        Location(
            roadName: "Gamal Abd Al Nasser Street",
            cityName: "6 October city",
            coordinates: CLLocationCoordinate2D(latitude:30.00620 , longitude:30.96839),
           // description: "Pothole in the middle of the road.",
            imageName: [
             "pothole3"
            ]
        ),
        
        Location(
            roadName: "Al Wahat Road",
            cityName: "6 October city",
            coordinates: CLLocationCoordinate2D(latitude:29.97262 , longitude:31.00669),
          //  description: "Pothole in the left side of the road.",
            imageName: [
             "pothole4"
            ]
        ),
        
        Location(
            roadName: "26th july axis Rd",
            cityName: "6 October city",
            coordinates: CLLocationCoordinate2D(latitude:30.00866 , longitude:30.99187),
          //  description: "Cracks in the left side of the road.",
            imageName: [
             "crack1"
            ]
        ),
        
        Location(
            roadName: "Waslet Dahshur Rd",
            cityName: "Sheikh Zayed City",
            coordinates: CLLocationCoordinate2D(latitude:30.02976 , longitude:30.96388),
          //  description: "Cracks in the rigth side of the road.",
            imageName: [
             "crack2"
            ]
        ),
        
        Location(
            roadName: "Gamal Abd Al Nasser St",
            cityName: "6 October city",
            coordinates: CLLocationCoordinate2D(latitude:30.00379 , longitude:30.96491),
      //      description: "Cracks in the middle of the road.",
            imageName: [
             "crack3"
            ]
        ),
        
        Location(
            roadName: "Al Wahat Rd",
            cityName: "6 October city",
            coordinates: CLLocationCoordinate2D(latitude:29.96919 , longitude:31.01779),
   //         description: "Cracks in the right side of the road.",
            imageName: [
             "crack4"
            ]
        ),
    ]
    
}
