//
//  LocationView.swift
//  RoadAssistant
//
//  Created by Youssif Hany on 25/02/2022.
//

import SwiftUI
import MapKit

struct LocationView: View {
    
    @EnvironmentObject private var vm: LocationViewModel
    
    var body: some View {
        NavigationView {
            ZStack{
                        Map(coordinateRegion: $vm.mapRegion,
                            annotationItems: vm.defects,
                            annotationContent: { defect in
                            MapAnnotation(coordinate: defect.coordinates){
                                AnnotationView()
                                    .scaleEffect(vm.mapLocation == defect ? 1 : 0.7)
                                    .shadow(radius: 20)
                                    .onTapGesture {
                                        vm.nextLocation(defect: defect)
                                    }
                            }
                        })
                            .ignoresSafeArea()
                    
                    VStack(spacing:0){

                        header
                            .padding()
                        
                      // searchButton
                        addReportButton
                        
                        
                        Spacer()
                        
                        // perview section
                        ZStack{
                            ForEach(vm.defects){ defect in
                                if  vm.mapLocation == defect {
                                    LocationPerviewView(defect: defect)
                                        .shadow(color: Color.black.opacity(0.3), radius: 20)
                                        .padding()
                                        .transition(.asymmetric(insertion: .move(edge: .trailing),
                                        removal: .move(edge: .leading)))
                                }
                            }
                        }
                    }
                }
                .sheet(item: $vm.sheetLocation, onDismiss: nil){ defect in
                    LocationDetailView(defect: defect)
            }
                .navigationBarHidden(true)
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LocationView()
                .environmentObject(LocationViewModel())
        }
    }
}


extension LocationView{
    private var header: some View{
        VStack {
            Button{
                vm.showLocationsList.toggle()
            }label: {
            Text("Search")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .frame(height:55)
                    .frame(maxWidth: .infinity)
                    .animation(.none,value: vm.mapLocation)
                    .overlay(alignment: .leading){
                        Image(systemName: "magnifyingglass")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding()
                            .rotationEffect(Angle(
                                degrees: vm.showLocationsList ? 180 : 0))
                }
            }
//            if vm.showLocationsList{
//                    LocationsListView()
//            }
        }
        .sheet(isPresented: $vm.showLocationsList, content: {
            LocationsListView()
        })
        .background(.thickMaterial)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 15)
        
        
        
    }
    
    private var addReportButton : some View{
        
  
            ZStack {
                HStack{
                        Spacer()
                    NavigationLink(destination:CameraView()){
                            Image(systemName: "camera.viewfinder")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:30,height: 30)
                                .padding(.bottom,50)
                        }
                        .foregroundColor(.primary)
                        .buttonStyle(.borderless)
                        .padding()
                        .padding(.trailing,20)
            }
            }
        
    }

    }
