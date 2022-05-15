//
//  CameraView.swift
//  RoadAssistant
//
//  Created by Youssif Hany on 25/02/2022.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct UserReportView: View {
    
    @EnvironmentObject var vm : LocationViewModel
    @ObservedObject var locationManager = LocationManager.shared
    
    @State var reportAlert: Bool = false
    @State var showSheet: Bool = false
    @State var userLocationExplanation: Bool = false
 
    
    var body: some View {
        NavigationView {
                VStack{
                    header
                    .sheet(isPresented: $showSheet, content: {
                        InfoView()
                    })
                    
                    
                    if let image = vm.image {
                        ZoomableScrollView {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(minWidth:0,maxWidth: .infinity)
                        }
                    }else{
                        Image(systemName: "photo.fill")
                            .resizable()
                            .scaledToFit()
                            .opacity(0.6)
                            .frame(minWidth:0,maxWidth: .infinity)
                            .padding(.horizontal)
                    }
                    VStack{
                        
                        
                            defectTextFields
                            .padding()
                        
                        VStack {
                            currentLocation
                            .padding()
                            
                            reportButton
        
                            .alert(isPresented: $reportAlert, content: {
                                Alert(
                                    title: Text("Report saved ✅"),
                                    message: Text("Thank you 😘")
                                )
                        })
                        }
                        cameraOptionsButtons
                        .padding()
                    }
                    Spacer()
                }
                .sheet(isPresented: $vm.showPicker){
                    ImagePicker(sourceType: vm.source == .library ? .photoLibrary : .camera, selectedImage: $vm.image)
                        .ignoresSafeArea()
                }
                .alert("Error", isPresented: $vm.showFileAlert, presenting: vm.appError,actions:{ cameraError in
                    cameraError.button
                }, message:{ cameraError in
                    Text(cameraError.message)
                })
            .navigationBarHidden(true)
            }
        }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        UserReportView()
            .environmentObject(LocationViewModel())
    }
}


extension UserReportView{
    private var cameraOptionsButtons: some View{
        HStack{
            Button{
                vm.source = .camera
                vm.showPhotoPicker()
            }label: {
                CameraButtonsView(symbolName: "camera", label: "Camera")
            }
            .alert("Error", isPresented: $vm.showCameraAlert, presenting: vm.cameraError,actions:{ cameraError in
                cameraError.button
            }, message:{ cameraError in
                Text(cameraError.message)
            })


            Button{
                vm.source = .library
                vm.showPhotoPicker()
            }label: {
                CameraButtonsView(symbolName: "photo", label: "Photo")
            }
            
        }
    }
    
    private var header : some View{
        HStack {
            Text("Report a road defect.")
                .font(.title)
                .padding()
            
            Button
            {
                showSheet.toggle()
            }label:{
                Image(systemName:"info.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width:30,height: 30)
                    .padding()
            }
        }
    }
    private var defectTextFields : some View{
        VStack{
            
            TextField("Defect Road Name", text: $vm.defectRoadName){isEditing in
                vm.isEditing = isEditing
                    
            }
            .padding()
            TextField("Defect City Name", text: $vm.defectCityName){isEditing in
                vm.isEditing = isEditing
                    
            }
            .padding()
        }
        .textFieldStyle(.roundedBorder)
        .font(.title2)
        
    }
    //MARK: REPORT LOCATION
    private var currentLocation: some View{
//        Button{
//
//        }label: {
//        Text("Use Current Location")
//                .font(.headline)
//                .padding()
//                .frame(height:40)
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(15)
//        }

        LocationButton(){
            vm.reportLocationBTPressed.toggle()
            LocationManager.shared.requstLocation()
            
       if let locationCoordinate = locationManager.userLocation?.coordinate{
                print(locationCoordinate)
            }
        }
        .font(.body)
        .foregroundColor(.white)
        .cornerRadius(8)
//        .onLongPressGesture{
//            userLocationExplanation.toggle()
//        }
//        .alert(isPresented: $userLocationExplanation, content: {
//            Alert(
//                title: Text("Current Location Button Explanation"),
//                message: Text("This button allows us to get the defect specific coordinates")
//            )
//        })
        
    }
    
    //MARK: SUBMIT REPORT BT
    private var reportButton: some View{
        HStack {
            Button{
                
                SoundManager.instance.playSound()
                vm.reset()
                reportAlert.toggle()
                
            }label: {
                CameraButtonsView(
                    symbolName:"square.and.arrow.up.fill",
                    label:"Report")
            }
            .disabled(vm.userReportValidation)
            .opacity(vm.userReportValidation ? 0.6 : 1)
        }
    }
}
