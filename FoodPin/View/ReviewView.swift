//
//  ReviewView.swift
//  FoodPin
//
//  Created by Ihor Dolhalov on 13.12.2023.
//

import SwiftUI


struct ReviewView: View {
    @Binding var isDisplayed: Bool
    @State private var showRatings = false
    var restaurant: Restaurant

    var body: some View {
        ZStack {
            
            Image(restaurant.image)
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity)
                .ignoresSafeArea()
            
                     Color.black //чорний фон
                .opacity(0.1)
                .background(.ultraThinMaterial) // Blur effect
                .ignoresSafeArea()
            
            HStack { //кнопка Х
                    Spacer()
                VStack {
                    Button(action: {
                        withAnimation(.easeOut(duration: 0.3)) {
                                self.isDisplayed = false
                            }
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 30.0))
                            .foregroundColor(.white)
                            .padding()
                    }
                       Spacer()
                }
            } //HStack closed
            
            VStack(alignment: .leading) {
                ForEach(Restaurant.Rating.allCases, id: \.self) { rating in
                    HStack {
                        Image(rating.image)
                        Text(rating.rawValue.capitalized)
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .animation(.easeOut.delay(Double(Restaurant.Rating.allCases.firstIndex(of:rating)!) * 0.05), value: showRatings)
                    .onTapGesture {
                        self.restaurant.rating = rating
                        self.isDisplayed = false
                    }
                    
                }
                
                }
                .opacity(showRatings ? 1.0 : 0)
                .offset(x: showRatings ? 0 : 1000) // модіфікатор смещения на 100 поинтов
                .onAppear {
                    showRatings.toggle()
                }
                
        } //ZStack closed
            
            
            
    }
}

#Preview {
    ReviewView( isDisplayed: .constant(true), restaurant: Restaurant(name: "Cafe Deadend", type: "Coffee & Tea Shop", location: "G/F, 72 Po Hing Fong, Sheung Wan, Hong Kong", phone: "232-923423", description: "Searching for great breakfast eateries and coffee? This place is for you. We open at 6:30 every morning, and close at 9 PM. We offer espresso and espresso based drink, such as capuccino, cafe latte, piccolo and many more. Come over and enjoy a great meal.", image: "cafedeadend", isFavorite: true))
}
