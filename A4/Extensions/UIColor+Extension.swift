//
//  UIColor+Extension.swift
//  A4
//
//  Created by Vin Bui on 10/31/23.
//

import UIKit

extension UIColor {

    // YOU MAY EDIT THIS FILE IF YOU ARE ATTEMPTING EXTRA CREDIT

    static let a4 = A4()

    struct A4 {
        let black = UIColor.black
        let offWhite = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        let silver = UIColor(red: 191/255, green: 191/255, blue: 191/255, alpha: 1)
        let white = UIColor.white
        let yellowOrange = UIColor(red: 255/255, green: 170/255, blue: 51/255, alpha: 1)
    
    }

}

extension UIColor {
    var hexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "#%02lX%02lX%02lX",
                      Int(r * 255),
                      Int(g * 255),
                      Int(b * 255))
    }
    
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexSanitized.hasPrefix("#") {
            hexSanitized.removeFirst()
        }

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = CGFloat((rgb >> 16) & 0xFF) / 255
        let g = CGFloat((rgb >> 8) & 0xFF) / 255
        let b = CGFloat(rgb & 0xFF) / 255

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

