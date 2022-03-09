//
//  RoadAssistantApp.swift
//  RoadAssistant
//
//  Created by Youssif Hany on 25/02/2022.
//

import SwiftUI

@main
struct RoadAssistantApp: App {
    
    @StateObject private var vm = LocationViewModel()
    
    
    var body: some Scene {
        WindowGroup {
//            LocationView()
//                .environmentObject(vm)
//                .onAppear{
//                    UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
//                }
            HomeScreen()
                .environmentObject(vm)
                .onAppear{
                    UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                }
        }
    }
}
