//
//  EditOrderView.swift
//  lab2
//
//  Created by IPZ-31   on 03.10.2024.
//

import SwiftUI

struct EditOrderView: View {
    @State var order: Order
    var onSave: (Order) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        Form {
            TextField("Product name", text: $order.productName)
            TextField("Number of poroduct", text: $order.productCount)
            
            Button("Save"){
                onSave(order)
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
