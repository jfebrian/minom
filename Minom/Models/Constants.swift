//
//  Constants.swift
//  Minom
//
//  Created by Joanda Febrian on 28/04/21.
//

import UIKit

struct ID {
    static let titleCell = "MinuteTitleCell"
    static let itemCell = "MinuteItemCell"
    static let buttonCell = "ButtonCell"
    static let calendarCell = "CalendarCell"
}

struct Segue {
    static let viewParticipants = "viewParticipants"
    static let addNewMinute = "AddNewMinute"
}

struct Storyboard {
    static let Main = UIStoryboard(name: "Main", bundle: nil)
    static let MeetingCreation = UIStoryboard(name: "MeetingCreation", bundle: nil)
    static let MinutesTaking = UIStoryboard(name: "MinutesTaking", bundle: nil)
    struct ID {
        static var MeetingItem: UIViewController {
            let sb = Storyboard.MinutesTaking
            return sb.instantiateViewController(identifier: "MeetingItem")
        }
        static var ViewParticipants: UIViewController {
            let sb = Storyboard.MinutesTaking
            return sb.instantiateViewController(identifier: "ViewParticipants")
        }
        static var MeetingAgenda: UIViewController {
            let sb = Storyboard.MeetingCreation
            return sb.instantiateViewController(identifier: "MeetingAgenda")
        }
        static var AddParticipant: UIViewController {
            let sb = Storyboard.MeetingCreation
            return sb.instantiateViewController(withIdentifier: "AddParticipant")
        }
    }
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
    static let Trash = UIImage(systemName: "trash")!
    static let Pencil = UIImage(systemName: "pencil")!
    static let BackArrow = UIImage(systemName: "chevron.backward")!
    static let People = UIImage(systemName: "person.3.fill")!
    static let Checkmark = UIImage(systemName: "checkmark")!
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
    static let Placeholder = UIColor(named: "Placeholder")
}
