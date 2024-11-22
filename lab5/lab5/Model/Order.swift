//
//  Order.swift
//  lab5
//
//  Created by IPZ-31 on 22.11.2024.
//

import Foundation

struct Order: Identifiable {
    var id = UUID()
    
    var productName: String
    var productCount: String
    var type: String
}
