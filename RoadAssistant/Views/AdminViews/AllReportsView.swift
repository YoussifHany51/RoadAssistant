//
//  AllReportsView.swift
//  RoadAssistant
//
//  Created by Youssif Hany on 08/03/2022.
//

import SwiftUI

struct AllReportsView: View {
    @EnvironmentObject var vm : LocationViewModel
    @State var showAlert: Bool = false
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(vm.myImages){ myImage in
                    HStack {
                        NavigationLink(destination:CameraView()) {
                            HStack{
                                Image(uiImage: myImage.image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width:100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .shadow(color: .black.opacity(0.6), radius: 2,
                                            x: 2, y: 2)
                                    .padding()
                                
                                
                                VStack(alignment: .leading){
                                    Text(myImage.description)
                                        .font(.title)
                                        .foregroundColor(.primary)
                                    Text(myImage.roadName)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth:.infinity,alignment: .leading)
                                .padding()
                            }
                            .onTapGesture{
                                vm.display(myImage)
                            }
                        }
                        Button{
                            print("checkmark")
                            showAlert.toggle()
                        }label: {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width:30,height: 30)
                                .foregroundColor(.green)
                                .padding()
                            
                        }
                    }
                    .alert(isPresented: $showAlert, content: {
                        Alert(
                            title: Text("Report added to Database ✅")
                        )
                    })
                }
                
            }
            .task {
                if FileManager().docExist(named: fileName){
                    vm.loadMyImagesJSONFile()
                }
            }
            .navigationBarHidden(true)
        }
        
    }
    
    
    struct AllReportsView_Previews: PreviewProvider {
        static var previews: some View {
            AllReportsView()
                .environmentObject(LocationViewModel())
        }
    }
}
