//
//  NotificationExample.swift
//  SwiftUI testing
//
//  Created by Glenn Olsson on 2020-05-24.
//  Copyright © 2020 Glenn Olsson. All rights reserved.
//

import SwiftUI

struct NotificationExample: View {
	var body: some View {
		NotificationStack {
			NotificationExampleSubview()
		}
	}
}

struct NotificationExampleSubview: View {
	
	@EnvironmentObject var notificationContext: NotificationContext
	
	var body: some View {
		VStack {
			Button(action: {
				self.notificationContext.addNotification(type: .standard, text: "Simple notification")
			}) {
				Text("Show a simple standard notification")
			}.padding()
			Button(action: {
				self.notificationContext.addNotification(type: .error) { uuid in
					HStack {
						Image(systemName: "suit.club.fill")
						Divider()
						VStack {
							Text("This is more advanced, agree?")
							Button(action: {
								self.notificationContext.removeNotification(id: uuid)
							}, label: {
								Text("Remove this")
							})
						}
					}
				}
			}) {
				Text("Add a more advanced error notification")
			}.padding()
		}
	}
}
