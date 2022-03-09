//
//  HomeScreen.swift
//  RoadAssistant
//
//  Created by Youssif Hany on 05/03/2022.
//

import SwiftUI

struct HomeScreen: View {
    
    @State var isAdmin:Bool = false
    @State var isUser:Bool = false
    @State var passWord:String = ""
    
    
    var body: some View {
        NavigationView {
            ZStack{
                LinearGradient(gradient: Gradient(colors: [.gray,.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                .edgesIgnoringSafeArea(.all)
              
                
                VStack(spacing:30){
                    
                    if isAdmin{
                        HStack{
                            TextField("Enter password here...",text: $passWord)
                                .font(.title2)
                                                        
                                if passWord == "Hi"{
                                    NavigationLink("Submit",
                                    destination: AdminView()
                                    .navigationTitle("")
                                    .navigationBarHidden(true)
                                    )
                                }

                        }
                        .padding()
                    }
                    
                    Text("Road Assistant")
                        .foregroundColor(.white)
                        .font(.system(size:36,design: .serif))
                        .fontWeight(.black)
                        .padding()
                    
                    Image("home")
                        .resizable()
                        .frame(width:300,height: 300)
                        .scaledToFit()
                        .clipShape(Circle())
                        .padding()
                        
                    
                    HStack {
                        Button{
                            isAdmin.toggle()
                        }label: {
                CameraButtonsView(symbolName: "house.fill", label: "Admin")
                        }
                        
                        
                        
                        Spacer()
                        
                        Button{
                            isUser.toggle()
                        }label: {
                CameraButtonsView(symbolName: "person.fill", label: "User")
                        }
                        
                    }
                    .padding()
                    Spacer()
                    
                 
                    
                    if isUser{
                        NavigationLink(
                        destination: LocationView()
                        .navigationTitle("")
                        .navigationBarHidden(true)
                        ){
                            Text("GO")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding()
                                .clipShape(Circle())
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                
            }
          
        }
        
    }
    
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
