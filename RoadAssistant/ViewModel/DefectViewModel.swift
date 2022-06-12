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
import FirebaseStorage

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
    @Published var fetchImage = [UIImage]()
    @Published var fetchedDefect : Defect? = nil
    
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
        retrieveDefectImage()
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
    func pushReport(roadName:String,coordinates:CLLocationCoordinate2D){
        
        let latitude = coordinates.latitude
        let longitude = coordinates.longitude

        self.ref.child("Defect").childByAutoId().setValue(
            ["roadName": roadName,"latitude": latitude,"longitude":longitude])
        
    }
    
    
    func uploadDefectImage(image:UIImage){
        
        // Create storage reference
        let storageRef = Storage.storage().reference()
        
        // Turn our image into Data
        let imageData =  image.jpegData(compressionQuality: 0.8)
        
        // Check that we can convert it to Data
        guard imageData != nil else{return}
        
        // Specify the file path
        let path = "DefectImages/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(path)
        
        // Upload that Data
        let uploadImage = fileRef.putData(imageData!,metadata: nil) {
            metaData,error in
            
            // Check for errors
            if error == nil && metaData != nil {
                
                //  Save a reference to the file in Firestore DB
                let db = Firestore.firestore()
                db.collection("images").document().setData(["url":path])
                
            }
            print(error?.localizedDescription as Any)
        }
        
    }
    
    func retrieveDefectImage(){
        
        let db = Firestore.firestore()
        
        db.collection("images").getDocuments { snapshot, error in
            
            if error == nil && snapshot != nil {
                
                var paths = [String]()
                // Loop through all the returned docs
                for doc in snapshot!.documents {
                    
                    paths.append(doc["url"] as! String)
                    
                }
                // Loop through each file & fetch data from storage
                for path in paths {
                    // Get reference to storage
                    let storageRef = Storage.storage().reference()
                    
                    // Specify the path
                    let fileRef = storageRef.child(path)
                    
                    // Retrieve data
                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                        
                        if error == nil && data != nil {
                            
                            if let image = UIImage(data: data!) {
                                
                                DispatchQueue.main.async {
                                    self.fetchImage.append(image)
                                }
                            }
                        }
                    }
                }
                
            }
        }
        
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
                
                for var item in arrayOfValues{
                    print(item)
                    
                    for image in self.fetchImage {
                     let img = self.convertUIImageToString(image: image)
                    
                    item.imageName = img
                    }
                    
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
