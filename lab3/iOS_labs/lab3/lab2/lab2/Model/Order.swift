//
//  Order.swift
//  lab2
//
//  Created by IPZ-31   on 03.10.2024.
//

import Foundation

struct Order: Identifiable {
    var id = UUID()
    
    var productName: String
    var productCount: String
    var type: String
}
