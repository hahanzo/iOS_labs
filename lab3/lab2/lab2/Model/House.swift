//
//  House.swift
//  lab2
//
//  Created by IPZ-31 on 26.09.2024.
//

import Foundation

struct House: Identifiable {
    var id = UUID()
    
    var roomCount: String
    var areaHouse: String
    var pool: Bool
}
