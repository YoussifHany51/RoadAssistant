//
//  LocationsListView.swift
//  RoadAssistant
//
//  Created by Youssif Hany on 25/02/2022.
//

import SwiftUI

struct LocationsListView: View {
    
    @EnvironmentObject private var vm : DefectViewModel

    @State var searchText = ""
    
    
    var body: some View {
        NavigationView{
            ZStack {
                List{
                    ForEach(filterList){ defect in
                        Button{
                            vm.nextLocation(defect: defect)
                            vm.showLocationsList = false
                        } label: {
                            listRowView(defect: defect)
                        }
                        .padding(.vertical,4)
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Search for road name")
                .searchable(text: $searchText)
            }
        }
        
    }

    var filterList : [Defect]{
        return vm.defects.filter{ $0.roadName.contains(searchText)}
    }
    
    
}

struct LocationsListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsListView()
            .environmentObject(DefectViewModel())
    }
}


extension LocationsListView {
    
    private func listRowView(defect: Defect) -> some View {
        HStack{
            if let imageName = defect.imageName.first{
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width:45,height: 45)
                    .cornerRadius(10)
            }
            
            VStack(alignment: .leading){
                Text(defect.roadName)
                    .font(.headline)
            }
            .frame(maxWidth:.infinity,alignment: .leading)
        }
    }
}
