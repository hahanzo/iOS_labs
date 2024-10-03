//
//  HouseView.swift
//  lab2
//
//  Created by IPZ-31 on 26.09.2024.
//

import SwiftUI

struct HouseView: View {
    
    @State private var roomCuont: String = ""
    @State private var areaHouse: String = ""
    @State private var poolSelected = false
    
    @ObservedObject var viewModel = HouseViewModel()
    
    var body: some View {
        VStack(spacing: 10) {
            Text("House List")
            TextField("Room Count", text: $roomCuont)
                .frame(width: 250, height: 40)
                .border(.secondary)

            TextField("Area house", text: $areaHouse)
                .frame(width: 250, height: 40)
                .border(.secondary)

            Toggle(isOn: $poolSelected){
                    Text("Pool selected")
                }.frame(width: 250,height: 40)
            
            Button("Add house to list", action: {
                viewModel.addHouse(roomCount: roomCuont, areaHouse: areaHouse, pool: poolSelected)
            }).frame(width: 250, height: 40)
                .border(.secondary)
            
        }
        List(viewModel.houses){
            houses in Text("Room count:\(houses.roomCount), Area:\(houses.areaHouse) m2, Is has pool:\(houses.pool)")
        }
    }
}

#Preview {
    HouseView()
}
