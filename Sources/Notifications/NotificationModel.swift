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
	
	init(text: String, type: NotificationType) {
		self.content = { AnyView(Text(text)) }
		self.type = type
		self.id = UUID()
	}
	
	init<Content: View>(type: NotificationType, @ViewBuilder content: @escaping () -> Content) {
		self.content = { AnyView(content()) }
		self.type = type
		self.id = UUID()
	}
}
