//
//  LoadingView.swift
//  RoadAssistant
//
//  Created by Youssif Hany on 29/06/2022.
//

import SwiftUI

struct LoadingView: View {
    @State var animate = false
    var body: some View {
        VStack{
            Circle()
                .trim(from: 0, to: 0.8)
                .stroke(AngularGradient(gradient:
                        .init(colors:
                                [.red,.orange]),center: .center),
                        style: StrokeStyle(lineWidth:8,
                                           lineCap: .round))
                .frame(width:45,height: 45)
                .rotationEffect(.init(degrees: self.animate ? 360 : 0))
                .animation(Animation.linear(duration: 0.7).repeatForever(), value: animate)
        }
        .background(Color.white)
        .cornerRadius(15)
        .onAppear{
            self.animate.toggle()
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
