//
//  UserDefaults.swift
//  lab5
//
//  Created by IPZ-31 on 22.11.2024.
//

import Foundation
import SwiftUI

extension UserDefaults {
    func set(color: Color, forKey key: String) {
        let components = color.cgColor?.components ?? [0, 0, 0, 1]
        let rgba = (r: components[0], g: components[1], b: components[2], a: components[3])
        let colorData = [
            "r": rgba.r,
            "g": rgba.g,
            "b": rgba.b,
            "a": rgba.a
        ]
        self.set(colorData, forKey: key)
    }
    
    func color(forKey key: String) -> Color{
        guard let colorData = self.dictionary(forKey: key) else {
            return Color.white
        }
        
        let r = colorData["r"] as? CGFloat ?? 0
        let g = colorData["g"] as? CGFloat ?? 0
        let b = colorData["b"] as? CGFloat ?? 0
        let a = colorData["a"] as? CGFloat ?? 1
                
        return Color(red: r, green: g, blue: b, opacity: a)
    }
}
