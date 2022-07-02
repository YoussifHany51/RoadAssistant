//
//  NoInternetvIEW.swift
//  RoadAssistant
//
//  Created by Youssif Hany on 29/06/2022.
//

import SwiftUI

struct NoInternetView: View {
    var body: some View {
        NavigationView{
            VStack{
                Image(systemName: "wifi.slash")
                    .resizable()
                    .scaledToFit()
                    .frame(width:50,height: 50)
                Text("No Internet Connection")
                    .font(.headline)
            }
            .navigationBarHidden(true)
        }
    }
}

struct NoInternetvIEW_Previews: PreviewProvider {
    static var previews: some View {
        NoInternetView()
    }
}
