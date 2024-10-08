//
//  HouseViewModel.swift
//  lab2
//
//  Created by IPZ-31 on 27.09.2024.
//

import Foundation

class OrdersViewModel: ObservableObject {
    @Published var orders: [Order] = []
    
    func addOrder(productName: String, count: String, type: String){
        let newOrder = Order(productName: productName, productCount: count,type: type)
        
        orders.append(newOrder)
    }
    
    func updateOrder(updatedOrder: Order){
        if let index = orders.firstIndex(where: {$0.id == updatedOrder.id}){
            orders[index] = updatedOrder
        }
    }
    
    func deleteOrder(order: Order){
        orders.removeAll {$0.id == order.id}
    }
}
