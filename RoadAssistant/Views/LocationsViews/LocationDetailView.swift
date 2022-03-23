//
//  LocationDetailView.swift
//  RoadAssistant
//
//  Created by Youssif Hany on 25/02/2022.
//

import SwiftUI
import MapKit

struct LocationDetailView: View {
    
    @EnvironmentObject private var vm: LocationViewModel
    let location:Location
    
    var body: some View {
        ScrollView{
            VStack{
                imageSection
                    .shadow(color: Color.black.opacity(0.3),
                            radius: 20,x:0,y:10)
                
                VStack(alignment: .leading, spacing: 16){
                    
                    titleSection
                    
//                Divider()
//                    
//                    descriptionSection
                    
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
        LocationDetailView(location: LocationsDataService.locations.first!)
            .environmentObject(LocationViewModel())
    }
}


extension LocationDetailView {
    
    private var imageSection :  some View{
        TabView{
            ForEach(location.imageName, id: \.self){
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
            Text(location.roadName)
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text(location.cityName)
                .font(.title)
                .foregroundColor(.secondary)
        }
    }
    
//    private var descriptionSection : some View{
//        VStack(alignment: .leading, spacing: 8){
//            Text(location.description)
//                .font(.subheadline)
//                .foregroundColor(.primary)
//        }
//    }
    
    private var mapLayer : some View{
        
        Map(coordinateRegion: .constant(MKCoordinateRegion(
            center: location.coordinates,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0))),
            annotationItems: [location]) { location in
            MapAnnotation(coordinate: location.coordinates){
                AnnotationView()
                    .scaleEffect(vm.mapLocation == location ? 1 : 0.7)
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

