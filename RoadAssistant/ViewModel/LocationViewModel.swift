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

class LocationViewModel: ObservableObject {
    // Camera and Photo picker ViewModel
    @Published var image : UIImage?
    @Published var showPicker = false
    @Published var source: Picker.Source = .library
    @Published var showCameraAlert = false
    @Published var cameraError: Picker.CameraErrorType?
    
    @Published var defectRoadName: String = ""
    @Published var defectCityName: String = ""
    @Published var isEditing = false
    @Published var showFileAlert = false
    @Published var reportLocationBTPressed = false
    @Published var appError: MyImageError.ErrorType?
    
    
    func reset(){
        image = nil
        defectRoadName = ""
        defectCityName = ""
    }

    
    var userReportValidation: Bool{
      image == nil || defectRoadName.isEmpty || defectCityName.isEmpty || reportLocationBTPressed == false
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
    
    @Published var defects: [Defect]

    
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
        
        
        // Camera and Photo picker ViewModel
       // print(FileManager.docDirURL.path)
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
}
