//
//  MainView.swift
//  FoodPin
//
//  Created by Ihor Dolhalov on 27.12.2023.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTabIndex = 0
    
    var body: some View {
       
        TabView(selection: $selectedTabIndex) {
            RestaurantListView()
                .tabItem {
                    Label("Favorites", systemImage: "tag.fill")
                }
                .tag(0)
            
            
            Text("Discover")
                .tabItem {
                    Label("Discover", systemImage: "wand.and.rays")
                }
                .tag(1)
            
            
            AboutView()
                .tabItem {
                    Label("About", systemImage: "square.stack")
                }
                .tag(2)
        }
        .accentColor(Color("NavigationBarTitle"))
        
        
        
    }
}

#Preview {
    MainView()
}
