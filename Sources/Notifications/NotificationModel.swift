//
//  NotificationModel.swift
//  
//
//  Created by Glenn Olsson on 2020-05-24.
//

import Foundation
import SwiftUI

enum NotificationType {
	case standard, error
}

/**
Model a notification to be displayed
*/
struct NotificationModel {
	var type: NotificationType
	var id: UUID
	
	var content: () -> AnyView
	
	/**
	- Parameters:
	    - type : The notification type to be associated with the notification
	    - text: The text the notification will display
	*/
	init(type: NotificationType, text: String) {
		self.content = { AnyView(Text(text)) }
		self.type = type
		self.id = UUID()
	}
	
	/**
	- parameters:
	    - type : The notification type to be associated with the notification
	    - content: The closure will be called with the id of the notification
	*/
	init<Content: View>(type: NotificationType, @ViewBuilder content: @escaping (UUID) -> Content) {
		self.type = type
		let id = UUID()
		self.id = id
		self.content = { AnyView(content(id)) }
	}
}
