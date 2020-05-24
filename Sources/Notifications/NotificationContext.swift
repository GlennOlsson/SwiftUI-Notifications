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
			let notification = NotificationModel(text: text, type: type)
		DispatchQueue.main.async {
			self.notifications.append(notification)
		}
	}
	
	/**
	Add notification with custom content view
	*/
	func addNotification<Content: View>(type: NotificationType, @ViewBuilder content: @escaping () -> Content) {
		let notification = NotificationModel(type: type, content: content)
		DispatchQueue.main.async {
			self.notifications.append(notification)
		}
	}
	
	func addNotification(notification: NotificationModel) {
		self.notifications.append(notification)
	}
}

