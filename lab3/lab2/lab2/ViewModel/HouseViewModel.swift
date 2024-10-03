//
//  HouseViewModel.swift
//  lab2
//
//  Created by IPZ-31 on 27.09.2024.
//

import Foundation

class HouseViewModel: ObservableObject {
    @Published var houses: [House] = []
    
    func addHouse(roomCount: String, areaHouse: String, pool: Bool){
        let newHouse = House(roomCount: roomCount, areaHouse: areaHouse, pool: pool)
        
        houses.append(newHouse)
    }
}
