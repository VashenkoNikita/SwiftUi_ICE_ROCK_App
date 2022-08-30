//
//  HapticManager.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 27.07.2022.
//

import SwiftUI

class HapticManager {
    static private var generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
