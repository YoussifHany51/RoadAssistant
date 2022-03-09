//
//  LocationsListView.swift
//  RoadAssistant
//
//  Created by Youssif Hany on 25/02/2022.
//

import SwiftUI

struct LocationsListView: View {
    
    @EnvironmentObject private var vm : LocationViewModel

    @State var searchText = ""
    
    
    var body: some View {
        NavigationView{
            ZStack {
                List{
                    ForEach(filterList){ location in
                        Button{
                            vm.nextLocation(location: location)
                            vm.showLocationsList = false
                        } label: {
                            listRowView(location: location)
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

    var filterList : [Location]{
        return vm.locations.filter{ $0.roadName.contains(searchText)}
    }
    
    
}

struct LocationsListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsListView()
            .environmentObject(LocationViewModel())
    }
}


extension LocationsListView {
    
    private func listRowView(location: Location) -> some View {
        HStack{
            if let imageName = location.imageName.first{
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width:45,height: 45)
                    .cornerRadius(10)
            }
            
            VStack(alignment: .leading){
                Text(location.roadName)
                    .font(.headline)
                Text(location.cityName)
                    .font(.subheadline)
            }
            .frame(maxWidth:.infinity,alignment: .leading)
        }
    }
}
