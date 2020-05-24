//
//  File.swift
//  
//
//  Created by Glenn Olsson on 2020-05-24.
//

import Foundation
import SwiftUI

/**
Context used to publish notifications

- Tag: NotificationContext
*/
class NotificationContext: ObservableObject {
	
	@Published var notifications: [NotificationModel] = []
	
	/**
	Add notification with plain text. This will be wrapped in a Text label
	*/
	func addNotification(type: NotificationType, text: String) {
		let notification = NotificationModel(type: type, text: text)
		self.addNotification(notification: notification)
	}
	
	/**
	Add notification with custom content view
	*/
	func addNotification<Content: View>(type: NotificationType, @ViewBuilder content: @escaping (UUID) -> Content) {
		let notification = NotificationModel(type: type, content: content)
		self.addNotification(notification: notification)
	}
	
	func addNotification(notification: NotificationModel) {
		DispatchQueue.main.async {
			self.notifications.append(notification)
		}
	}
	
	func removeNotification(id: UUID) {
		notifications.removeAll(where: {$0.id == id})
	}
}

