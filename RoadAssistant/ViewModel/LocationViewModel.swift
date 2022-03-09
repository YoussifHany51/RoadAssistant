//
//  LocationViewModel.swift
//  RoadAssistant
//
//  Created by Youssif Hany on 25/02/2022.
//

import Foundation
import MapKit
import SwiftUI

class LocationViewModel: ObservableObject {
    // Camera and Photo picker ViewModel
    @Published var image : UIImage?
    @Published var showPicker = false
    @Published var source: Picker.Source = .library
    @Published var showCameraAlert = false
    @Published var cameraError: Picker.CameraErrorType?
    @Published var imageDescription: String = ""
    @Published var defectRoadName: String = ""
    @Published var isEditing = false
    @Published var selectedImage: MyImage?
    @Published var myImages: [MyImage] = []
    @Published var showFileAlert = false
    @Published var appError: MyImageError.ErrorType?
    
    
    
    func reset(){
        image = nil
        imageDescription = ""
        defectRoadName = ""
    }
    
    func display(_ myImage: MyImage){
        image = myImage.image
        imageDescription = myImage.description
        defectRoadName = myImage.roadName
        selectedImage = myImage
    }

    func updateSelected(){
        if let index = myImages.firstIndex(where: {$0.id == selectedImage!.id}){
            myImages[index].description = imageDescription
            myImages[index].roadName = defectRoadName
            saveMyImagesJSONfile()
            reset()
        }
    }
    
    func deleteSelected(){
        if let index = myImages.firstIndex(where: {$0.id == selectedImage!.id}){
            myImages.remove(at: index)
            saveMyImagesJSONfile()
            reset()
        }
    }
        
    func addImage(_ description: String, _ roadName: String, image: UIImage){
        reset()
        let myImage = MyImage(description: description, roadName: roadName)

        do{
            try FileManager().saveImage("\(myImage.id)", image: image)
            myImages.append(myImage)
            saveMyImagesJSONfile()
        }catch{
            showFileAlert = true
            appError = MyImageError.ErrorType(error: error as! MyImageError)
        }
    }
    
    
    
    func saveMyImagesJSONfile(){
        let encoder = JSONEncoder()

        do{
            let data = try encoder.encode(myImages)
            let jsonString = String(decoding: data, as: UTF8.self)
            do{
                try FileManager().saveDocument(contents: jsonString)
            }catch{
                showFileAlert = true
                appError = MyImageError.ErrorType(error: error as! MyImageError)
            }
        }catch{
            showFileAlert = true
            appError = MyImageError.ErrorType(error: .encodingError)
        }
    }
    
    func loadMyImagesJSONFile(){
        do{
            let data = try FileManager().readDocument()
            let decoder = JSONDecoder()
            do{
                myImages = try decoder.decode([MyImage].self,from: data)
            }catch{
                showFileAlert = true
                appError = MyImageError.ErrorType(error: .decodingError)
            }
        }catch{
            showFileAlert = true
            appError = MyImageError.ErrorType(error: error as! MyImageError)
        }
    }
    
    
    var buttonDisabled: Bool{
        imageDescription.isEmpty || image == nil || defectRoadName.isEmpty
    }
    
    var deleteButtonIsHidden: Bool{
        isEditing || selectedImage == nil
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
    
    @Published var locations: [Location]

    
    @Published var mapLocation : Location {
        didSet{
            updateMapRegion(location: mapLocation)
        }
    }
    
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta:0.1)
    
    
    @Published var showLocationsList: Bool = false
    
    @Published var sheetLocation: Location? = nil
    
    
    //MARK: init func
    init(){
        // location viewModel
        let locations = LocationsDataService.locations
        self.locations = locations
        self.mapLocation = locations.first!
        self.updateMapRegion(location: locations.first!)
        
        
        // Camera and Photo picker ViewModel
       // print(FileManager.docDirURL.path)
    }
    
    private func updateMapRegion(location:Location){
        withAnimation(.easeInOut){
            mapRegion = MKCoordinateRegion(
                center: location.coordinates,
                span: mapSpan)
        }
    }

    
    
    func toggleLocationList(){
        withAnimation(.easeInOut){
            showLocationsList.toggle()
        }
    }
    
    func nextLocation(location: Location){
        withAnimation(.easeInOut){
            mapLocation = location
            showLocationsList = false
        }
    }
    
    func nextButtonPressed(){
        
        guard  let currIndex = locations.firstIndex (where: {$0 == mapLocation})else {
            return
        }
        
        let nextIndex = currIndex + 1
        guard locations.indices.contains(nextIndex)else {
            
            guard  let firstIndex = locations.first else { return }
            nextLocation(location: firstIndex)
            return
        }
        let nextLoc = locations[nextIndex]
        nextLocation(location: nextLoc)
    }
}
