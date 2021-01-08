//
//  UIColor.swift
//  RMRobots
//
//  Created by Maksim Dmitrenko on 08.01.2021.
//

import UIKit

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        switch hexSanitized.count {
        case 6:
            let mask = 0x0000FF
            r = CGFloat(Int(rgb >> 16) & mask) / 255.0
            g = CGFloat(Int(rgb >> 8) & mask) / 255.0
            b = CGFloat(Int(rgb) & mask) / 255.0
        case 8:
            let mask = 0x000000FF
            r = CGFloat(Int(rgb >> 24) & mask) / 255.0
            g = CGFloat(Int(rgb >> 16) & mask) / 255.0
            b = CGFloat(Int(rgb >> 8) & mask) / 255.0
            a = CGFloat(Int(rgb) & mask) / 255.0
        default:
            return nil
        }
        
        self.init(red:r, green:g, blue:b, alpha:a)
    }
}
