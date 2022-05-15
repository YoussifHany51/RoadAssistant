//
//  RoadAssistantApp.swift
//  RoadAssistant
//
//  Created by Youssif Hany on 25/02/2022.
//

import SwiftUI
import Firebase
import UIKit
@main
struct RoadAssistantApp: App {
    
    @StateObject private var vm = DefectViewModel()
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            LocationView()
                .environmentObject(vm)
                .onAppear{
                    UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                }
        }
    }
}
