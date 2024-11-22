//
//  SettingsView.swift
//  lab5
//
//  Created by IPZ-31 on 22.11.2024.
//

import SwiftUI

struct SettingsView: View {
    @Binding var fontSize: CGFloat
    @Binding var backgroundColor: Color
    
    var body: some View {
        VStack {
            Text("Settings")
                .font(.title)
            VStack(alignment: .leading) {
                Text("Font Size")
                Slider(value: $fontSize, in: 10...30, step: 1)
                ColorPicker("Select Background Color", selection: $backgroundColor)
                    .padding()
            }
            Button("Save") {
                UserDefaults.standard.set(fontSize, forKey: "fontSize")
                UserDefaults.standard.set(color: backgroundColor, forKey: "backgroundColor")
            }.padding()
        }.padding()
    }
}
