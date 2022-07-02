//
//  CameraView.swift
//  RoadAssistant
//
//  Created by Youssif Hany on 25/02/2022.
//

import SwiftUI
import MapKit
import CoreLocationUI

extension View{
    func dismissKeyBoard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),to: nil,from: nil,for: nil)
    }
}


struct UserReportView: View {
    
    @EnvironmentObject var vm : DefectViewModel
    @StateObject var viewModel = DefectViewModel()
    @ObservedObject var locationManager = LocationManager.shared
    
    @State var reportAlert: Bool = false
    @State var defectLocationAlert: Bool = false
    @State var showSheet: Bool = false
    @State var userLocationExplanation: Bool = false
    
    var body: some View {
        NavigationView {
            VStack{
                header
//                    .sheet(isPresented: $showSheet, content: {
//                        InfoView()
//                    })
                
                
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
                            .alert(isPresented: $defectLocationAlert, content: {
                                Alert(
                                    title: Text("Location Saved !")
                                )
                            })
                        
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
                .onTapGesture {
                    self.dismissKeyBoard()
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
            .environmentObject(DefectViewModel())
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
            
//            Button
//            {
//                showSheet.toggle()
//            }label:{
//                Image(systemName:"info.circle")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width:30,height: 30)
//                    .padding()
//            }
        }
    }
    //MARK: Text Field
    private var defectTextFields : some View{
        VStack{
            
            TextField("Defect Road Name", text: $vm.defectRoadName){isEditing in
                vm.isEditing = isEditing
                
            }
            .padding(.horizontal)
            .frame(height:55)
            .background(Color.gray.opacity(0.3))
            .cornerRadius(10)
            .font(.title)
        }
        
    }
    //MARK: REPORT LOCATION
    private var currentLocation: some View{
        Button{
            vm.reportLocationBTPressed.toggle()
            LocationManager.shared.requstLocation()
            
            
            if let locationCoordinate = locationManager.userLocation?.coordinate{
                vm.defectLocation = locationCoordinate
                defectLocationAlert.toggle()
                print(locationCoordinate)
            }
            else {
                print("Location Extraction Faild")
            }
        }label: {
            Text("Defect Location")
                .font(.callout)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .clipShape(Capsule())
        }
        
    }
    
    //MARK: REPORT Button
    private var reportButton: some View{
        HStack {
            Button{
                viewModel.pushReport(roadName:vm.defectRoadName,coordinates: vm.defectLocation)
                viewModel.uploadDefectImage(image: vm.image!)
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
