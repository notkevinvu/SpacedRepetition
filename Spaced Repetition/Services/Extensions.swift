//
//  Extensions.swift
//  Spaced Repetition
//
//  Created by Kevin Vu on 4/21/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import UIKit

extension UIColor {
    // public failable init (returns nil if we don't initialize with a parameter correctly)
    public convenience init?(hex: String, alpha: CGFloat = 1.0) {
        let r, g, b: CGFloat
        
        if hex.count == 6 {
            let scanner = Scanner(string: hex)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                b = CGFloat(hexNumber & 0x0000ff) / 255
                
                self.init(red: r, green: g, blue: b, alpha: alpha)
                return
            }
        }
        
        return nil
        
        // example initializer:
        // let gold = UIColor(hex: "ffe700")
    }
}

