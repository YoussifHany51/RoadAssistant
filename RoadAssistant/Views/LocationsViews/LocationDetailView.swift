//
//  LocationDetailView.swift
//  RoadAssistant
//
//  Created by Youssif Hany on 25/02/2022.
//

import SwiftUI
import MapKit

struct LocationDetailView: View {
    
    @EnvironmentObject private var vm: DefectViewModel
    let defect:Defect
    
    var body: some View {
        ScrollView{
            VStack{
                if defect.imageName.isEmpty{
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width:UIScreen.main.bounds.width)
                        .clipped()
                }else{
                imageSection
                    .shadow(color: Color.black.opacity(0.3),
                            radius: 20,x:0,y:10)
                }
                VStack(alignment: .leading, spacing: 16){
                    
                    titleSection
                    
                Divider()
                    
                    mapLayer
                    
                    
                }
                .frame(maxWidth:.infinity,alignment: .leading)
                .padding()
            }
        }
        .ignoresSafeArea()
        .background(.ultraThinMaterial)
        .overlay(backButton, alignment: .topLeading)
    }
}

struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LocationDetailView(defect: LocationsDataService.defects.first!)
            .environmentObject(DefectViewModel())
    }
}


extension LocationDetailView {
    
    private var imageSection :  some View{
        TabView{
            ForEach(defect.imageName, id: \.self){
                Image($0)
                    .resizable()
                    .scaledToFill()
                    .frame(width:UIScreen.main.bounds.width)
                    .clipped()
            }
        }
        .frame(height:500)
        .tabViewStyle(PageTabViewStyle())
    }
    
    
    private var titleSection : some View{
        VStack(alignment: .leading, spacing: 8){
            Text(defect.roadName)
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text(defect.cityName)
                .font(.title)
                .foregroundColor(.secondary)
        }
    }
    
    
    private var mapLayer : some View{
        
        Map(coordinateRegion: .constant(MKCoordinateRegion(
            center: defect.coordinates,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0))),
            annotationItems: [defect]) { defect in
            MapAnnotation(coordinate: defect.coordinates){
                AnnotationView()
                    .scaleEffect(vm.mapLocation == defect ? 1 : 0.7)
                    .shadow(radius: 20)
            }
        }
            .allowsHitTesting(false)
            .aspectRatio(1, contentMode: .fit)
            .cornerRadius(30)
    }
    
    private var backButton: some View{
        Button{
          vm.sheetLocation = nil
        } label:{
            Image(systemName: "xmark")
                .font(.headline)
                .padding(16)
                .foregroundColor(.primary)
                .background(.ultraThickMaterial)
                .cornerRadius(10)
                .shadow(radius: 4)
                .padding()
        }
    }
}

