//
//  AppDelegate.swift
//  Minom
//
//  Created by Joanda Febrian on 28/04/21.
//

import UIKit
import RealmSwift
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    lazy var realm:Realm = {
        return try! Realm()
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Migration Block
        let schema: UInt64 = 2
        
        let config = Realm.Configuration(
            schemaVersion: schema,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < schema) {
                }
            })
        
        Realm.Configuration.defaultConfiguration = config
        
        do {
            if realm.objects(User.self).isEmpty {
                try realm.write {
                    let user = User()
                    realm.add(user)
                    
                    let dailyStandups = MeetingType()
                    dailyStandups.name = "Daily Standup"
                    let sprintPlanning = MeetingType()
                    sprintPlanning.name = "Sprint Planning"
                    let sprintReview = MeetingType()
                    sprintReview.name = "Sprint Review"
                    let retrospective = MeetingType()
                    retrospective.name = "Retrospective"
                    
                    let defaultTypes = [
                        dailyStandups,
                        sprintPlanning,
                        sprintReview,
                        retrospective
                    ]
                    
                    realm.add(defaultTypes)
                }
            }
        } catch {
            print("Error initiliazing new realm, \(error.localizedDescription)")
        }
        
        IQKeyboardManager.shared.enable = true
        
        return true
    }
    
    
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

