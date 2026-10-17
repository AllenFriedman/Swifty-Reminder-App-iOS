//
//  NotificationManager.swift
//  Swifty Reminder
//
//  Created by Aman Bind on 05/10/23.
//

import Foundation
import UserNotifications

struct UserData {
    let title: String?
    let body: String?
    let time: Date?
    let date: Date?
}

enum NotificationManager {
    // Used when a reminder has no notes of its own
    private static let spookyLines = [
        "The spirits say it's time...",
        "Boo! Did you forget about this?",
        "Don't keep the ghosts waiting.",
        "The witching hour has arrived.",
        "Something is lurking on your to-do list...",
    ]

    static func scheduleNotification(userData: UserData) {
        let content = UNMutableNotificationContent()
        content.title = "👻 " + (userData.title ?? "")
        if let body = userData.body, !body.isEmpty {
            content.body = body
        } else {
            content.body = spookyLines.randomElement() ?? ""
        }
        
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: userData.date ?? Date())
        
        if let reminderTime = userData.time {
            let reminderDateTimeComponents = reminderTime.dateComponents
            dateComponents.hour = reminderDateTimeComponents.hour
            dateComponents.minute = reminderDateTimeComponents.minute
        }
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: true)
        
        let uuidString = UUID().uuidString
    
        let request = UNNotificationRequest(identifier: uuidString,
                                            content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { error in
            if error != nil {
                // Handle any errors.
            }
            else {
                print("Reminder Added")
            }
        }
    }
}
