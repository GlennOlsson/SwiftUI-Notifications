//
//  NotificationStack.swift
//
//  Created by Glenn Olsson on 2020-05-24.
//

import Foundation
import SwiftUI

/**
Wrapper for the views to be able to recieve notifications on. Embeds a NotificationContext in the environment for the underlying views to push notifications

The context can be extracted with this line in the subviews declaration

    @EnvironmentObject var notificationContext: NotificationContext

- See also: NotificationContext
*/
struct NotificationStack<Content: View>: View {
	
	let content: () -> Content

	@ObservedObject var notificationContext: NotificationContext
	
	init(content: @escaping () -> Content) {
		self.content = content
		self.notificationContext = NotificationContext()
	}
	
	func removeNotification(notification: NotificationModel) {
		notificationContext.notifications.removeAll(where: {$0.id == notification.id})
	}
	
    var body: some View {
		return ZStack {
			ForEach(Array(notificationContext.notifications.enumerated()), id: \.1.id) { (index, notification) in
				NotificationView(notification: notification, onHide: self.removeNotification)
					.position(x: UIScreen.main.bounds.width * 0.5, y: 0)
						.zIndex(1)
			}
			
			content().environmentObject(self.notificationContext)
		}
    }
}

/**
The actual notification that is displayed
*/
private struct NotificationView: View {
	
	private let offset_isVisible: CGFloat = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
	private let offset_isInvisible: CGFloat = -100
	
	let height: CGFloat = 100
	
	@State var yValDiff: CGFloat = 0
	@State var opactity: Double = 1
	
	let notification: NotificationModel
	
	var type: NotificationType {
		notification.type
	}
	
	var content: AnyView {
		notification.content()
	}
	
	@State var isVisible: Bool = false
	
	let onHide: (NotificationModel) -> Void
	
	func hide() {
		let animationTime: Double = 2
		withAnimation(.linear(duration: animationTime)){
			self.isVisible = false
			self.yValDiff = 0
		}
		
		//After animation is done, remove notification from rendering
		DispatchQueue.main.asyncAfter(deadline: .now() + animationTime) {
			self.onHide(self.notification)
		}
	}
	
	init(notification: NotificationModel, onHide: @escaping (NotificationModel) -> Void) {
		self.notification = notification
		self.onHide = onHide
	}
	
	var offset: CGFloat {
		if self.isVisible {
			return offset_isVisible + self.yValDiff
		} else {
			return offset_isInvisible + self.yValDiff
		}
	}
	
	var notificationBackgrund: Color {
		if self.type == .standard {
			return Color.blue
		} else {
			return Color.red
		}
	}
	
	var body: some View {
		HStack {
			content
				.padding()
		}
		.frame(width: UIScreen.main.bounds.width * 0.9, height: self.height, alignment: .center)
		.background(self.notificationBackgrund)
			.animation(.none) //No animation for background color
		.cornerRadius(10)
		.offset(x: 0, y: self.offset)
		.shadow(radius: 5)
		.animation(.spring())
			.gesture(DragGesture()
			.onChanged({value in
				self.yValDiff = min(self.height * 0.4, value.translation.height)
			})
			.onEnded({value in
				//< .5 as we only want to be able to swipe up. -0.5 = 50% of the total height
				if value.translation.height / self.height < -0.5 {
					self.hide()
				} else {
					self.yValDiff = 0
				}
			}))
		.onAppear() {
			self.isVisible = true
		}
	}
}
