//
//  CameraView.swift
//  RoadAssistant
//
//  Created by Youssif Hany on 25/02/2022.
//

import SwiftUI

struct CameraView: View {
    
    @EnvironmentObject var vm : LocationViewModel
        
    
    @State var reportAlert: Bool = false
    @State var showSheet: Bool = false
 
    
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
                        // User used his current location
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
        CameraView()
            .environmentObject(LocationViewModel())
    }
}


extension CameraView{
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
            Text("Report a road defect to help us in improving the app accuracy.")
                .font(.title)
            .padding()
            
            Button
            {
                showSheet.toggle()
            }label:{
                Image(systemName:"info.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width:40,height: 40)
                .padding()
            }
        }
    }
    private var defectTextFields : some View{
        VStack{
            TextField("Defect Description", text: $vm.imageDescription){isEditing in
                vm.isEditing = isEditing
                    
            }
          
            
            TextField("Defect Road Name", text: $vm.defectRoadName){isEditing in
                vm.isEditing = isEditing
                    
            }
        }
        .textFieldStyle(.roundedBorder)
        .font(.title)
        .padding()
    }
    private var currentLocation: some View{
        Button{
        
        }label: {
        Text("Use Current Location")
                .font(.headline)
                .padding()
                .frame(height:40)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(15)
        }

    }
    //MARK: REPORT & UPDATE
    private var reportButton: some View{
        HStack {
            Button{
       if vm.selectedImage == nil {
           vm.addImage(vm.imageDescription, vm.defectRoadName, image:vm.image!)
       }else{
           vm.updateSelected()
       }
                SoundManager.instance.playSound()
                
                reportAlert.toggle()
                
            }label: {
                CameraButtonsView(
                    symbolName:"square.and.arrow.up.fill",
                    label:vm.selectedImage == nil ? "Report" : "Update")
            }
            .disabled(vm.buttonDisabled)
            .opacity(vm.buttonDisabled ? 0.6 : 1)
     //MARK: DELETE BUTTON
            if !vm.deleteButtonIsHidden{
                Button{
                    vm.deleteSelected()
                }label: {
                    CameraButtonsView(symbolName: "trash", label: "Delete")
                }
            }
        }
    }
}
