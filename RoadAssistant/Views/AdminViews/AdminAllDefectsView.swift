//
//  AdminAllDefectsView.swift
//  RoadAssistant
//
//  Created by Youssif Hany on 07/03/2022.
//

import SwiftUI

struct AdminAllDefectsView: View {
    
    @EnvironmentObject private var vm : LocationViewModel    
    
    var body: some View {
        NavigationView{
            ZStack {
                List{
                    ForEach(vm.locations){ location in
                        Button{
                            vm.nextLocation(location: location)
                            vm.showLocationsList = false
                        } label: {
                            listRowView(location: location)
                        }
                        .padding(.vertical,4)
                        .listRowBackground(Color.clear)
                    }
                    .onDelete(perform: deleteDefect)
                    .onMove(perform: moveDefect)
                }
                .listStyle(PlainListStyle())
                .navigationTitle("All Defects")
                .navigationBarItems(leading: EditButton())
                
            }
        }
    }
    
    
    
    func deleteDefect(index: IndexSet){
        vm.locations.remove(atOffsets: index)
    }
    
    func moveDefect(indices: IndexSet, newOffset: Int){
        vm.locations.move(fromOffsets: indices, toOffset: newOffset)
    }
}

struct AdminAllDefectsView_Previews: PreviewProvider {
    static var previews: some View {
        AdminAllDefectsView()
            .environmentObject(LocationViewModel())
    }
}


extension AdminAllDefectsView {
    
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
