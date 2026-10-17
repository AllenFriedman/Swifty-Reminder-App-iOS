//
//  Swifty_ReminderApp.swift
//  Swifty Reminder
//
//  Created by Aman Bind on 15/09/23.
//

import SwiftUI
import UserNotifications

@main
struct Swifty_ReminderApp: App {
    init() {
        // Schedule the request with the system.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in

            if granted {
                // request Notificaton
            }
            else {
                print(error?.localizedDescription as Any)
            }
        }

        // Halloween theme: pumpkin-orange navigation titles
        let pumpkin = UIColor(Color.pumpkin)
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: pumpkin]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: pumpkin]
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, CoreDataProvider.shared.persistentContainer.viewContext)
                .preferredColorScheme(.dark)
                .tint(Color.pumpkin)
        }
    }
}
