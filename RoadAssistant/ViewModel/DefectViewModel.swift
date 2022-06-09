//
//  LocationViewModel.swift
//  RoadAssistant
//
//  Created by Youssif Hany on 25/02/2022.
//

import Foundation
import MapKit
import SwiftUI
import CoreLocationUI
import Firebase
import UIKit
import FirebaseDatabase
import FirebaseDatabaseSwift
import CodableFirebase
import FirebaseFirestore
//import SwiftProtobuf

class DefectViewModel: ObservableObject {
    //MARK: Camera & Photo picker
    @Published var image : UIImage?
    @Published var showPicker = false
    @Published var source: Picker.Source = .library
    @Published var showCameraAlert = false
    @Published var cameraError: Picker.CameraErrorType?
    
    @Published var defectRoadName: String = ""
    @Published var defectLocation: CLLocationCoordinate2D =
    CLLocationCoordinate2D(latitude:0 , longitude:0)
    @Published var isEditing = false
    @Published var showFileAlert = false
    @Published var reportLocationBTPressed = false
    @Published var appError: MyImageError.ErrorType?
    @Published var fetchData = [Defect]()
    
    func reset(){
        image = nil
        defectRoadName = ""
    }
    
    
    var userReportValidation: Bool{
        image == nil || defectRoadName.isEmpty || reportLocationBTPressed == false
    }
    
    
    func showPhotoPicker(){
        do{
            if source == .camera{
                try Picker.checkPermissions()
            }
            showPicker = true
        } catch{
            showCameraAlert = true
            cameraError = Picker.CameraErrorType(error: error as! Picker.PickerError)
        }
    }
    
    
    // MARK: LOCATION VIEW MODEL
    
    @Published var defects = [Defect]()
    
    
    @Published var mapLocation : Defect {
        didSet{
            updateMapRegion(defect: mapLocation)
        }
    }
    
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta:0.1)
    
    
    @Published var showLocationsList: Bool = false
    
    @Published var sheetLocation: Defect? = nil
    
    
    //MARK: init func
    init(){
        // location viewModel
        let defects = LocationsDataService.defects
        self.defects = defects
        self.mapLocation = defects.first!
        self.updateMapRegion(defect: defects.first!)
        fetchDefects()
    }
    
    private func updateMapRegion(defect:Defect){
        withAnimation(.easeInOut){
            mapRegion = MKCoordinateRegion(
                center: defect.coordinates,
                span: mapSpan)
        }
    }
    
    func toggleLocationList(){
        withAnimation(.easeInOut){
            showLocationsList.toggle()
        }
    }
    
    func nextLocation(defect: Defect){
        withAnimation(.easeInOut){
            mapLocation = defect
            showLocationsList = false
        }
    }
    
    func nextButtonPressed(){
        
        guard  let currIndex = defects.firstIndex (where: {$0 == mapLocation}) else { return }
        
        let nextIndex = currIndex + 1
        guard defects.indices.contains(nextIndex)else {
            
            guard  let firstIndex = defects.first else { return }
            nextLocation(defect: firstIndex)
            return
        }
        let nextLoc = defects[nextIndex]
        nextLocation(defect: nextLoc)
    }
    //   MARK: Firebase DB
    
    func convertUIImageToString (image: UIImage) -> [String] {
        
        var imageAsData: Data = image.pngData()!
        var imageAsInt: Int = 0 // initialize
        
        let data = NSData(bytes: &imageAsData, length: MemoryLayout<Int>.size)
        data.getBytes(&imageAsInt, length: MemoryLayout<Int>.size)
        
        let imageAsString: String = String (imageAsInt)
        
        var res:[String] = []
        res.append(imageAsString)
        
        return res
        
    }
    var ref : DatabaseReference! = Database.database().reference()
    var number = 0;
    func pushReport(roadName:String,coordinates:CLLocationCoordinate2D,image:UIImage){
        
        let img = convertUIImageToString(image: image)
        let latitude = coordinates.latitude
        let longitude = coordinates.longitude
//        let defectObj = Defect(roadName: roadName, coordinates: coordinates, imageName: img)
        
//        let defectDictionary:[String:Any] = [
//            "roadName" : defectObj.roadName,
//            "coordinates" : defectObj.coordinates,
//            "imageName" : defectObj.imageName] as [String : Any]
        
//        ref.child("DefectInfo").childByAutoId().setValue(defectDictionary.description,
//                                                         withCompletionBlock: {error ,ref in
//            if let error = error {
//                print("DefectInfoDictionary was not saved: \(error.localizedDescription)")
//            }else{
//                print("DefectInfoDictionary saved successfully!")
//                self.number+=1
//            }
//        })

        self.ref.child("Defect").childByAutoId().setValue(
            ["roadName": roadName,"latitude": latitude,"longitude":longitude,"imageName": img])
        
    }

    
    
    func fetchDefects(){
        self.ref.child("Defect").observe(.value) { snapshot in
            guard let value = snapshot.value else {return}
            
            print(snapshot.key)
            print(value)
            
            do{
                let model = try FirebaseDecoder().decode([String:Defect].self, from: value)
                print(model)
                let arrayOfKeys = Array(model.keys.map{ $0 })
                print(arrayOfKeys) // [1, 2, 3]
                let arrayOfValues = Array(model.values.map{ $0 })
                print(arrayOfValues)
                
                for item in arrayOfValues{
                    print(item)
                    self.defects.append(item)
                }
            } catch let error {
                print(error)
            }
        }withCancel: { error in
            print(error.localizedDescription)
        }
        
  }
    
    
    
}
