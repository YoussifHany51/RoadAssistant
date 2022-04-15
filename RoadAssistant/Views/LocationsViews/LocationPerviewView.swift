//
//  LocationPerviewView.swift
//  RoadAssistant
//
//  Created by Youssif Hany on 25/02/2022.
//

import SwiftUI

struct LocationPerviewView: View {
    
    @EnvironmentObject private var vm : LocationViewModel
    
    let defect: Defect
    
    var body: some View {
        HStack (alignment:.bottom,spacing: 0){
            
            VStack(alignment:.leading,spacing:16){
                
                imageSection
                
                titleSection
            }
            
            VStack(spacing:8){
                
                nextButton
                learnMoreButton
                
                
            }
        }
        .padding(20)
        .background(
        RoundedRectangle(cornerRadius: 10)
            .fill(.ultraThinMaterial)
            .offset(y:65)
        )
        .cornerRadius(10)
    }
}

struct LocationPerviewView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            LocationPerviewView(defect: LocationsDataService.defects.first!)
                .padding()
        }
        .environmentObject(LocationViewModel())
    }
}


extension LocationPerviewView {
    
    private var imageSection: some View{
        ZStack{
            if let imageName =  defect.imageName.first{
                Image(imageName)
                    .resizable()
                    .scaleEffect()
                    .frame(width:100,height: 100)
                    .cornerRadius(10)
                
            }
        }
        .padding(6)
        .background(Color.white)
        .cornerRadius(10)
    }
    
    private var titleSection : some View{
        VStack (alignment: .leading, spacing: 4){
            Text(defect.roadName)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(defect.cityName)
                .font(.subheadline)
        }
        .frame(maxWidth:.infinity,alignment: .leading)
    }
    
    private var learnMoreButton : some View {
        Button{
            vm.sheetLocation = defect
        } label: {
            Text("Learn more")
                .font(.headline)
                .frame(width: 125, height: 35)
        }
        .buttonStyle(.borderedProminent)
    }
        
    
    private var nextButton : some View {
        Button{
          vm.nextButtonPressed()
        } label: {
            Text("Next")
                .font(.headline)
                .frame(width: 125, height: 35)
        }
        .buttonStyle(.bordered)
    }
}
