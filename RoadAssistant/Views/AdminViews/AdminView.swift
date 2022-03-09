//
//  AdminView.swift
//  RoadAssistant
//
//  Created by Youssif Hany on 05/03/2022.
//

import SwiftUI

struct AdminView: View {
    
    @State var isAllDefects:Bool = false
    @State var isReport:Bool = false
    
    var body: some View {
        
        NavigationView {
            ZStack{
                LinearGradient(gradient: Gradient(colors: [.gray,.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                .edgesIgnoringSafeArea(.all)
                VStack{
                    
                    HStack{
                        NavigationLink(destination: AdminAllDefectsView()){
                            Text("View All Defects")
                                .font(.headline)
                                .padding()
                                .frame(height:40)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }
                        
                        NavigationLink(destination: AllReportsView()){
                            Text("View All Reports")
                                .font(.headline)
                                .padding()
                                .frame(height:40)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }
                    }
                    .padding()
                Spacer()
                }
                
            }
            .navigationTitle("Admin 👋")
        }
    }
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView()
    }
}
