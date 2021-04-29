//
//  Constants.swift
//  Minom
//
//  Created by Joanda Febrian on 28/04/21.
//

import UIKit

struct K {
    static let minuteCellIdentifier = "MinutesCell"
}

struct Font {
    static func LexendDeca(_ size: CGFloat) -> UIFont {
        return UIFont(name: "LexendDeca-Regular", size: size)!
    }
    
    static func RobotoLight(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Light", size: size)!
    }
    
    static func RobotoRegular(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: size)!
    }
    
    static func RobotoMedium(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Medium", size: size)!
    }
}

struct Color {
    static let BackgroundSecondary = UIColor(named: "Background Secondary")!
    static let Background = UIColor(named: "Background")!
    static let LabelGrey = UIColor(named: "Label Grey")!
    static let LabelJungle = UIColor(named: "Label Jungle")!
    static let MenuJungle = UIColor(named: "Menu Jungle")!
    static let EmeraldGreen = UIColor(named: "Green Emerald")!
    static let MiddleBlueGreen = UIColor(named: "Green Middle Blue")!
    static let GreenSheen = UIColor(named: "Green Sheen")!
    static let MidnightGreen = UIColor(named: "Green Midnight")!
    static let JungleGreen = UIColor(named: "Green Jungle")!
    static let Grey = UIColor(named: "Grey")!
}
