//
//  RestaurantDetailView.swift
//  FoodPin
//
//  Created by Ihor Dolhalov on 20.09.2023.
//

import SwiftUI

struct RestaurantDetailView: View {
    @Environment(\.dismiss) var dismiss //для кастомной кнопки назад
    var restaurant: Restaurant
    var body: some View {
        
       // if restaurant.isFavorite { heartColor = .yellow } else {heartColor = .white  }
        /*     ZStack (alignment: .top) {
            Image(restaurant.image)
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity)
            .ignoresSafeArea()
  
            Color.black
                    .frame(height: 100)
                    .opacity(0.8)
                    .cornerRadius(20)
                    .padding()
                    .overlay {
                        VStack(spacing: 5) {
                            Text(restaurant.name)
                            Text(restaurant.type)
                            Text(restaurant.location)
                        }
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(.white)
                    }
        }*/
        
        ScrollView {
            VStack (alignment: .leading) {
             
      //          if restaurant.isFavorite { heartColor = .yellow } else {heartColor = .white  }
                Image(restaurant.image)
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 350)
                    .overlay {
                        VStack {
                            

                            Image(systemName: restaurant.isFavorite ? "heart.fill": "heart")
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topTrailing)
                                .padding()
                                .font(.system(size: 30))
                    
                                .foregroundColor(restaurant.isFavorite ? .yellow : .white)
                            
                                .padding(.top, 40)
                            VStack(alignment: .leading, spacing: 5) {
                                Text(restaurant.name)
                                    .font(.custom("Nunito-Regular", size: 35, relativeTo: .largeTitle))
                                    .bold()
                                Text(restaurant.type)
                                    .font(.system(.headline, design: .rounded))
                                    .padding(.all, 5)
                                    .background(Color.black)
                                
                            } //vstack finished
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottomLeading)
                            .foregroundColor(.white)
                            .padding()
                            
                        } //vstack finished
                    } //overlay finished
                Text(restaurant.description)
                    .padding()
                
                
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text("ADDRESS")
                            .font(.system(.headline, design: .rounded))
                        Text(restaurant.location)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading) {
                        Text("PHONE")
                            .font(.system(.headline, design: .rounded))
                        Text(restaurant.phone)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
                
                
                NavigationLink(
                    destination:
                        MapView(location: restaurant.location)
                            .edgesIgnoringSafeArea(.all)
                ) {
                    MapView(location: restaurant.location, interactionModes: [])
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 200)
                        .cornerRadius(20)
                        .padding()
                }

                
                
            } //main vstack finished
        }.ignoresSafeArea() // ScrollView finished
        
        
        //кастомна кнопка назад
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {  Text("\(Image(systemName: "chevron.left"))") }
            }
        } //toolbar finished
        
    }
}

struct RestaurantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RestaurantDetailView(restaurant: Restaurant(name: "Cafe Deadend", type: "Coffee & Tea Shop", location: "G/F, 72 Po Hing Fong, Sheung Wan, Hong Kong", phone: "232-923423", description: "Searching for great breakfast eateries and coffee? This place is for you. We open at 6:30 every morning, and close at 9 PM. We offer espresso and espresso based drink, such as capuccino, cafe latte, piccolo and many more. Come over and enjoy a great meal.", image: "cafedeadend", isFavorite: false))
}
        .accentColor(.white)
    }
}
