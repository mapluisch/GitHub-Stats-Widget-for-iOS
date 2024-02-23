//
//  NotificationManager.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 24.02.24.
//

import Foundation
import UserNotifications

class NotificationManager {
    static func scheduleNotification(title: String, body: String) {
        DispatchQueue.main.async {
            guard UserDefaults.standard.bool(forKey: "notifyOnStatsChange") else { return }
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }    
}
