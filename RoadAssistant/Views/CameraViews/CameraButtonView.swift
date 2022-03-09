//
//  CameraButtonView.swift
//  RoadAssistant
//
//  Created by Youssif Hany on 27/02/2022.
//

import SwiftUI

struct CameraButtonsView: View {
    
    let symbolName: String
    let label: String
    
    var body: some View {
        HStack {
            Image(systemName: symbolName)
            Text(label)
        }
        .font(.headline)
        .padding()
        .frame(height:40)
        .background(Color.red)
        .foregroundColor(.white)
        .cornerRadius(15)
    }
}

struct CameraButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        CameraButtonsView(symbolName: "camera", label: "Camera")
    }
}
