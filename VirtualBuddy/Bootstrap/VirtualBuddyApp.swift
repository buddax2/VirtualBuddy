//
//  VirtualBuddyApp.swift
//  VirtualBuddy
//
//  Created by Guilherme Rambo on 07/04/22.
//

import SwiftUI

@main
struct VirtualBuddyApp: App {
    @NSApplicationDelegateAdaptor
    var appDelegate: VirtualBuddyAppDelegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .presentedWindowToolbarStyle(.unifiedCompact)
                .onOpenURL { url in
                    guard let values = try? url.resourceValues(forKeys: [.contentTypeKey]) else { return }
                    guard values.contentType == .virtualBuddyVM else { return }
                    print(url.path)
                }
        }
    }
}