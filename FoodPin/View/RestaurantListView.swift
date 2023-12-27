//
//  ContentView.swift
//  FoodPin
//
//  Created by Ihor Dolhalov on 11.09.2023.
//

import SwiftUI

    // MARK: структура таблиці List
struct RestaurantListView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(
        entity: Restaurant.entity(),
        sortDescriptors: [])
    var restaurants: FetchedResults<Restaurant>
    
     @State private var showNewRestaurant = false
    
    @State private var searchText = ""
    
    @State private var showWalkthrough = false
    @AppStorage("hasViewedWalkthrough") var hasViewedWalkthrough: Bool = false //UserDefaults
    
    
    var body: some View {
        NavigationView {
            List {
                if restaurants.count == 0 {
                    Image("emptydata")
                        .resizable()
                        .scaledToFit()
                } else {
                    ForEach(restaurants.indices, id: \.self) { index in
                        ZStack(alignment: .leading) {
                            NavigationLink(destination: RestaurantDetailView(restaurant: restaurants[index])) {
                                EmptyView()
                            }.opacity(0)
                            BasicTextImageRow(restaurant: restaurants[index])
                        }
                    }
                    
                    /*                     //свайп зліва направо
                     .swipeActions(edge: .leading, allowsFullSwipe: false, content: {
                     Button {
                     } label: {
                     Image(systemName: "heart")
                     }
                     .tint(.green)// колір кнопки
                     
                     
                     Button {
                     } label: {
                     Image(systemName: "square.and.arrow.up")
                     }
                     .tint(.orange)
                     }
                     )
                     
                     
                     */
                    // свайп зправа наліво
                    .onDelete(perform: deleteRecord)
                    .listRowSeparator(.hidden) // убрать границы рядов
                }
            }
            .listStyle(.plain)
            .navigationTitle("FoodPin")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                Button(action: {
                    self.showNewRestaurant = true
                }) {
                    Image(systemName: "plus")
                }
            }
        } .accentColor(.primary) //кнопка  + зараз чорна
        
            .sheet(isPresented: $showNewRestaurant) {
            NewRestaurantView() //показать вью нового ресторана якшо $showNewRestaurant = true
        }
            .sheet(isPresented: $showWalkthrough) { //показувати TutorialView коли $showWalkthrough = true
                TutorialView()
            }
            .onAppear() {
                showWalkthrough = hasViewedWalkthrough ? false : true
            }
        
            .searchable(text: $searchText) //строка пошуку
            .onChange(of: searchText) { searchText in //сам механізм пошуку
                let predicate = searchText.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "name CONTAINS[c] %@ OR location CONTAINS[c]%@", searchText, searchText)
                restaurants.nsPredicate = predicate
            }
    }
    
    
        private func deleteRecord(indexSet: IndexSet) {
            
            for index in indexSet {
                let itemToDelete = restaurants[index]
                context.delete(itemToDelete)
            }

            DispatchQueue.main.async {
                do {
                    try context.save()

                } catch {
                    print(error)
                }
            }
        }
    }





// MARK: структура одного рядка таблиці List

struct BasicTextImageRow: View {
    
    @ObservedObject var restaurant: Restaurant
    
    @State private var showOptions = false
    @State private var showError = false
       
  
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            let imageData = restaurant.image
                Image(uiImage: UIImage(data: imageData) ?? UIImage())
                    .resizable()
                    .frame(width: 120, height: 118)
                    .cornerRadius(20)
            
            
            VStack(alignment: .leading) {
                Text(restaurant.name)
                    .font(.system(.title2, design: .rounded))
                
                Text(restaurant.type)
                    .font(.system(.body, design: .rounded))
                
                Text(restaurant.location)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.gray)
            }
            
            
            if restaurant.isFavorite {
                
                Spacer()
                Image(systemName: "heart.fill")
                    .foregroundColor(.yellow)
                
            }
        }
       
       // MARK: Context menu
        .contextMenu {
            Button(action: {
                self.showError.toggle()
            }) {
                HStack {
                    Text("Reserve a table")
                    Image(systemName: "phone")
                }
            }
            
            Button(action: {
                self.restaurant.isFavorite.toggle()
            }) {
                HStack {
                    Text(restaurant.isFavorite ? "Remove from favorites" : "Mark as favorite")
                    Image(systemName: "heart")
                }
            }
            
            Button(action: {
                self.showOptions.toggle()
            }) {
            HStack {
                    Text("Share")
                    Image(systemName: "square.and.arrow.up")
            }
            }
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Not yet available"),
                  message: Text("Sorry, this feature is not available yet. Please retry later."),
                                primaryButton: .default(Text("OK")),
                                secondaryButton: .cancel())
                  }
        
        
        // MARK: Activity Controller menu
        .sheet(isPresented: $showOptions) {
            
            let defaultText = "Just checking in at \(restaurant.name)"
            
            let imageData = restaurant.image
            let imageToShare = UIImage(data: imageData)
            ActivityView(activityItems: [defaultText, imageToShare])
          
        }
        
  /*
            .onTapGesture {
                showOptions.toggle()}
        // MARK: Menu ActionSheet
        .actionSheet(isPresented: $showOptions) {
            var ButtonText = ""
            if restaurant.isFavorite {
                ButtonText = "Unmark from favorite"} else {ButtonText = "Mark as favorite"}
           
            return ActionSheet(title: Text("What do you want to do?"),
                        message: nil,
                        buttons: [
                            .default(Text("Reserve a table")) {
                             self.showError.toggle()
                            },
                            .default(Text(ButtonText)) {
                                restaurant.isFavorite.toggle()
                            },
                            .cancel()
                        ])}
        .alert(isPresented: $showError) {
            Alert(title: Text("Not yet available"),
                  message: Text("Sorry, this feature is not available yet. Please retry later."),
                                primaryButton: .default(Text("OK")),
                                secondaryButton: .cancel())
                  }
        */
        
        
    }
}

// MARK: структура одного рядка таблиці List щоб змінити зовнішній вигляд. просто інший дизаїн

struct FullImageRow: View {
    var imageName: String
    var name: String
    var type: String
    var location: String
    @Binding var isFavorite: Bool
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .cornerRadius(20)
            
            VStack(alignment: .leading) {
                HStack{
                    Text(name)
                        .font(.system(.title2, design: .rounded))
                    if isFavorite {
                        Spacer()
                        Image(systemName: "heart.fill")
                            .foregroundColor(.yellow)
                    }
                
                }
                
                Text(type)
                    .font(.system(.body, design: .rounded))
                Text(location)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.gray)
                
               
                
            }
            
           
            .padding(.horizontal)
                .padding(.bottom)
        }}}
       



    
    // MARK: структура превью
struct RestaurantListView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        
        RestaurantListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .preferredColorScheme(.dark)
        
        BasicTextImageRow(restaurant: (PersistenceController.testData?.first)!)
            .previewLayout(.sizeThatFits)
        
        FullImageRow(imageName: "cafedeadend", name: "Cafe Deadend", type: "Cafe", location: "Hong Kong", isFavorite: .constant(true))
            .previewLayout(.sizeThatFits)
    }
}




