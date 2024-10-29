//
//  RunClubWidgetExtensionBundle.swift
//  RunClubWidgetExtension
//
//  Created by Alex Fogg on 30/10/2024.
//

import WidgetKit
import SwiftUI

@main
struct RunClubWidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        RunClubWidgetExtension()
        RunClubWidgetExtensionControl()
        RunClubWidgetExtensionLiveActivity()
    }
}
