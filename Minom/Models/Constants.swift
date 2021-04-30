//
//  Constants.swift
//  Minom
//
//  Created by Joanda Febrian on 28/04/21.
//

import UIKit

struct Storyboard {
    static let Main = UIStoryboard(name: "Main", bundle: nil)
    static let MeetingCreation = UIStoryboard(name: "MeetingCreation", bundle: nil)
    static let MinutesTaking = UIStoryboard(name: "MinutesTaking", bundle: nil)
}

struct Custom {
    static func separator(width: CGFloat) -> UIView {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 1))
        v.backgroundColor = Color.Grey
        return v
    }
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

struct Image {
    static let DatePickerBackground = UIImage(named: "Date Picker Background")!
    static let DatePickerBackgroundReverse = UIImage(named: "Date Picker Background Reverse")!
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
