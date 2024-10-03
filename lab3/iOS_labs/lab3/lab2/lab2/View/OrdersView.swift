//
//  HouseView.swift
//  lab2
//
//  Created by IPZ-31 on 26.09.2024.
//

import SwiftUI

struct OrdersView: View {
    @State private var productName: String = ""
    @State private var productCout: String = ""
    
    var type = ["food", "chemicals", "toys"]
    @State private var selectedType: String = "food"
    
    @State private var searchText: String = ""
    var filteredOrder: [Order]{
        if searchText.isEmpty {
            return viewModel.orders
        } else {
            return viewModel.orders.filter{$0.productName.localizedCaseInsensitiveContains(searchText)}
        }
    }
    
    @State private var selectedOrder: Order?
    @ObservedObject var viewModel = OrdersViewModel()

    
    var body: some View {
        VStack(spacing: 10) {
            Text("Orders List")
            TextField("Product name", text: $productName)
                .frame(width: 250, height: 40)
                .border(.secondary)

            TextField("Number of poroduct", text: $productCout)
                .frame(width: 250, height: 40)
                .border(.secondary)
            
            Picker("Products type", selection: $selectedType) {
                            ForEach(type, id: \.self) { fruit in
                                Text(fruit)
                            }
                        }
            
            TextField("Enter type to filter", text: $searchText)
                .frame(width: 250, height: 40)
                .border(.secondary)
            
            Button("Add order to list", action: {
                viewModel.addOrder(productName: productName, count: productCout, type: selectedType)
            }).frame(width: 250, height: 40)
                .border(.secondary)
        }
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
        .sheet(item: $selectedOrder){ order in
            EditOrderView(order: order, onSave: {updateOrder in
                viewModel.updateOrder(updatedOrder: updateOrder)
        })
    }
}

#Preview {
    OrdersView()
}
