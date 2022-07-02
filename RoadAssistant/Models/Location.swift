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
    var coordinates : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude:0 , longitude:0)
    var imageName : UIImage = UIImage()
    
    private enum CodingKeys: String, CodingKey {
        case roadName,coordinates,imageName,latitude,longitude
    }
    
    //Equatable
    static func == (lhs: Defect, rhs: Defect) -> Bool {
        lhs.id == rhs.id
    }
    init(roadName:String,coordinates:CLLocationCoordinate2D,imageName:UIImage) {
        
        self.roadName = roadName
        self.coordinates = coordinates
        self.imageName = imageName
    }
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        roadName = try values.decode(String.self,forKey: .roadName)
        coordinates.latitude = CLLocationDegrees(try values.decode(Double.self,forKey: .latitude))
        coordinates.longitude = CLLocationDegrees(try values.decode(Double.self,forKey: .longitude))
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
