//
//  RestaurantDetailView.swift
//  FoodPin
//
//  Created by Ihor Dolhalov on 20.09.2023.
//

import SwiftUI

struct RestaurantDetailView: View {
    @Environment(\.dismiss) var dismiss //для кастомной кнопки назад
    @Environment(\.managedObjectContext) var context //для core data
    
    @ObservedObject var restaurant: Restaurant

    @State private var showReview = false // контроллировать появление окна review
    
    var body: some View {
        
        ScrollView {
            VStack (alignment: .leading) {
                Image(uiImage: UIImage(data: restaurant.image)!)
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 350)
                    .overlay {
                        VStack {
                        /*            Image(systemName: restaurant.isFavorite ? "heart.fill": "heart")
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topTrailing)
                                .padding()
                                .font(.system(size: 30))
                            
                                .foregroundColor(restaurant.isFavorite ? .yellow : .white)
                            
                                .padding(.top, 40) */
                            
                            HStack(alignment: .bottom) {
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
                                
                                // показать рейтинг
                                if let rating = restaurant.rating, !showReview {
                                        Image(rating.image)
                                            .resizable()
                                            .frame(width: 60, height: 60)
                                            .padding([.bottom, .trailing])
                                            .transition(.scale)
                                } }
                                .animation(.spring(response: 0.2, dampingFraction: 0.3, blendDuration: 0.3
                                ), value: restaurant.rating)
                            
                            } //vstack finished
                        
                    } //overlay finished
                
                Text(restaurant.summary)
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
                
                //кнопка для рейтінга

                Button(action: {
                    self.showReview.toggle()
                }) {
                    Text("Rate it")
                        .font(.system(.headline, design: .rounded))
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
                .tint(Color("NavigationBarTitle")) // колір кнопки
                .buttonStyle(.borderedProminent) // повністю закрашена кнопка
                .buttonBorderShape(.roundedRectangle(radius: 25))
                .controlSize(.large) // розмір кнопки
                .padding(.horizontal)
                .padding(.bottom, 20)
            } //main vstack finished
            
            //кастомна кнопка назад
            .navigationBarBackButtonHidden(true) //заховати кнопку назад
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {  Text("\(Image(systemName: "chevron.left"))")
                    }
                    .opacity(showReview ? 0 : 1)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        restaurant.isFavorite.toggle()
                    }) {
                        Image(systemName: restaurant.isFavorite ? "heart.fill": "heart")
                            .font(.system(size: 25))
                            .foregroundColor(restaurant.isFavorite ? .yellow : .white)
                    }
                    .opacity(showReview ? 0 : 1)
                }
                 
            } //toolbar finished
            
            
            
            
        }.ignoresSafeArea() // ScrollView finished
            .overlay(
                self.showReview ?
                ZStack {
                    ReviewView(isDisplayed: $showReview, restaurant: restaurant)
                        .navigationBarHidden(true) //заховати кнопку назад
                }
                : nil
                )
            .onChange(of: restaurant) { _ in
                if self.context.hasChanges {
                    try? self.context.save()
                }
            }
    }
}

struct RestaurantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RestaurantDetailView(restaurant: (PersistenceController.testData?.first)!)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            
        }
        .accentColor(.white)
    }
}
