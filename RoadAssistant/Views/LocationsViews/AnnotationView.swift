//
//  AnnotationView.swift
//  RoadAssistant
//
//  Created by Youssif Hany on 25/02/2022.
//

import SwiftUI

struct AnnotationView: View {
    
    let accentColor = Color("AccentColor")
    
    var body: some View {
        VStack(spacing: 0){
            Image(systemName: "mappin")
                .resizable()
                .scaledToFit()
                .frame(width:30,height: 30)
                .font(.headline)
                .foregroundColor(.white)
                .padding(6)
                .background(Color.red)
                .clipShape(Circle())
            
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.red)
                .frame(width:10,height: 10)
                .rotationEffect(Angle(degrees: 180))
                .offset(y:-3)
                .padding(.bottom,40)
        }
    }
}

struct AnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        AnnotationView()
    }
}
