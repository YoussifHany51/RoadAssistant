//
//  InfoView.swift
//  RoadAssistant
//
//  Created by Youssif Hany on 02/03/2022.
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        
        ScrollView {
            VStack{
                Text("About us")
                    .padding()
                Divider()
                Text("Kindly we would like to announce that this app is a graduation project for university students at the faculty of computer science and this project is just a proof of concept and under trials and tests.")
                Text("The data which is shown on the app is real data taken by our AI kit.")
                Text("If you would like to help us in improving the quality and accuracy of the project, please report a defect that you have found on the road capture it using your phone camera and tell us in which lane of the road is itand the name of the road.")
                Text("Another method to improve the accuracy is by buying our AI model kit and putting it in your vehicle to capture the defects Automatically.")
                Text("Kindly when you add a report please write the road name in English only.")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                Spacer()
            }
            .font(.title)
            .padding()
        }

        
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
