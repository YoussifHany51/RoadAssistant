//
//  MyImage.swift
//  RoadAssistant
//
//  Created by Youssif Hany on 27/02/2022.
//


import UIKit


struct MyImage: Identifiable,Codable{
    var id = UUID()
    var reportedRoadName : String
    var reportedCityName : String
    
    var reportedImage: UIImage {
        do{
            return try FileManager().readImage(with: id)
        }catch{
            return UIImage(systemName: "photo.fill")!
        }
    }
}
