//
//  Location.swift
//  RoadAssistant
//
//  Created by Youssif Hany on 25/02/2022.
//

import Foundation
import MapKit


struct Defect : Identifiable , Equatable, Codable{
        
    var id = UUID().uuidString
    var roadName : String = ""
    var cityName : String = ""
    var coordinates : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude:0 , longitude:0)
    var imageName : [String] = []
    
    private enum CodingKeys: String, CodingKey {
        case roadName,cityName,coordinates,imageName
    }
    
    //Equatable
    static func == (lhs: Defect, rhs: Defect) -> Bool {
        lhs.id == rhs.id
    }
    init(roadName:String,cityName:String,coordinates:CLLocationCoordinate2D,imageName:[String]) {
        
        self.roadName = roadName
        self.cityName = cityName
        self.coordinates = coordinates
        self.imageName = imageName
    }
    
    
    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decode(String.self,forKey: .id)
//        roadName = try values.decode(String.self,forKey: .roadName)
//        cityName = try values.decode(String.self,forKey: .cityName)
//        coordinates = try values.decode(CLLocationCoordinate2D.self,forKey: .coordinates)
//        imageName = try values.decode([String].self,forKey: .imageName)
        
        
    }
    
    
    func encode(to encoder: Encoder) throws {
        
    }
    
    
    func createDic() -> [String: Any]? {
        guard let dic = self.dictionary else { return nil }
        return dic
    }
}
extension Encodable{
    var dictionary:[String:Any]?{
        guard let data = try? JSONEncoder().encode(self) else{return nil}
        return try? JSONSerialization.jsonObject(with: data,options: .fragmentsAllowed) as? [String:Any]
    }
}
