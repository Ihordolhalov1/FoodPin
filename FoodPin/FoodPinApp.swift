//
//  FoodPinApp.swift
//  FoodPin
//
//  Created by Ihor Dolhalov on 11.09.2023.
//

import SwiftUI

@main
struct FoodPinApp: App {
    
    // MARK: customize the font and color of the navigation bar
    init() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: 
                                                        UIColor(named: "NavigationBarTitle"),
            .font: UIFont(name: "ArialRoundedMTBold", size: 35)!]
        navBarAppearance.titleTextAttributes = [.foregroundColor:
                                                    UIColor(named: "NavigationBarTitle"),
            .font: UIFont(name: "ArialRoundedMTBold", size: 20)!]
        navBarAppearance.backgroundColor = .clear
        navBarAppearance.backgroundEffect = .none
        navBarAppearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
    }
    
    
    
    
    
    var body: some Scene {
        WindowGroup {
            RestaurantListView()
        }
    }
}
