//
//  OrdersView.swift
//  lab5
//
//  Created by IPZ-31 on 22.11.2024.
//

import SwiftUI

struct OrdersView: View {
    @State private var productName: String = ""
    @State private var productCout: String = ""
    @State private var showWarning: Bool = false
    @State private var fontSize: CGFloat = UserDefaults.standard.object(forKey: "fontSize") as? CGFloat ?? 16
    @State private var backgroundColor: Color = UserDefaults.standard.color(forKey: "backgroundColor")

    @State private var selectedType: String = "food"
    @State private var searchText: String = ""
    @State private var selectedOrder: Order?

    @ObservedObject var viewModel = OrdersViewModel()
    
    enum FoodType: String, CaseIterable {
        case food = "Food"
        case chemical = "Chem"
        case toys = "Toys"
        case drinks = "Drinks"
    }
    
    var filteredOrder: [Order]{
        if searchText.isEmpty {
            return viewModel.orders
        } else {
            return viewModel.orders.filter{$0.productName.localizedCaseInsensitiveContains(searchText)}
        }
    }
            
    var body: some View {
        NavigationView{
            VStack(spacing: 10) {
                HStack {
                    NavigationLink(destination: SettingsView(fontSize: $fontSize, backgroundColor: $backgroundColor)) {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                            .padding(10)
                            .background(Circle().fill(Color.white))
                            .shadow(radius: 5)
                    }
                    Spacer()
                }
                .padding(.leading, 10)
                
                if $viewModel.orders.isEmpty{
                    Spacer()
                }
                
                Text("Orders List")
                    .font(.system(size: fontSize))
                
                TextField("Product name", text: $productName)
                    .frame(width: 250, height: 40)
                    .border(.secondary)
                    .background(Color.white)
                
                TextField("Number of product", text: $productCout)
                    .frame(width: 250, height: 40)
                    .border(.secondary)
                    .background(Color.white)
                
                Picker("Products type", selection: $selectedType) {
                    ForEach(FoodType.allCases, id: \.self) { fruit in
                        Text(fruit.rawValue).tag(fruit.rawValue)
                    }
                }
                
                TextField("Enter type to filter", text: $searchText)
                    .frame(width: 250, height: 40)
                    .border(.secondary)
                    .background(Color.white)
                
                Button("Add order to list", action: {
                    viewModel.addOrder(productName: productName, count: productCout, type: selectedType)
                })
                .frame(width: 250, height: 40)
                .border(.secondary)
                .disabled(productName.isEmpty || productCout.isEmpty)
                .background(Color.white)
                
                if !$viewModel.orders.isEmpty {
                    List{
                        ForEach(filteredOrder){ order in
                            VStack (alignment: .leading){
                                Text("Product: \(order.productName)")
                                Text("Count: \(order.productCount)")
                                Text("Type: \(order.type)")
                            }.onTapGesture {
                                selectedOrder = order
                            }
                        }
                        .onDelete(perform: { indexSet in
                            indexSet.map {viewModel.orders[$0]}.forEach(viewModel.deleteOrder)
                        })
                    }
                    .background(backgroundColor)
                    .scrollContentBackground(.hidden)
                    .sheet(item: $selectedOrder){ order in
                        EditOrderView(order: order, onSave: {updateOrder in
                            viewModel.updateOrder(updatedOrder: updateOrder)
                        })
                    }
                }
                
                Spacer()
            }
            .background(backgroundColor)
        }
    }
}

