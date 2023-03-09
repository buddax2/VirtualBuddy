//
//  VBRestorableWindow.swift
//  VirtualUI
//
//  Created by Guilherme Rambo on 09/03/23.
//

import Cocoa

class VBRestorableWindow: NSWindow {

    override func close() {
        vbSaveFrame()

        super.close()
    }

    private var savedFrameKey: String? {
        guard let identifier, let screen else { return nil }
        guard let screenNumber = screen.deviceDescription[.init("NSScreenNumber")] as? Int else { return nil }

        return "window-\(identifier.rawValue)-\(screenNumber)"
    }

    private var savedFrame: NSRect? {
        guard let savedFrameKey else { return nil }
        guard let dict = UserDefaults.standard.dictionary(forKey: savedFrameKey) else { return nil }
        return NSRect(dictionaryRepresentation: dict as CFDictionary)
    }

    private var applicationWillTerminateObserver: Any?

    private var keyRequested = false

    override func makeKey() {
        super.makeKey()

        defer { keyRequested = true }

        if applicationWillTerminateObserver == nil {
            applicationWillTerminateObserver = NotificationCenter.default.addObserver(forName: NSApplication.willTerminateNotification, object: nil, queue: nil, using: { [weak self] _ in
                self?.vbSaveFrame()
            })
        }

        if !keyRequested, let savedFrame {
            setFrame(savedFrame, display: true)
        } else {
            vbSaveFrame()
        }
    }

    override func center() {
        guard savedFrame == nil else {
            makeKey()
            return
        }

        super.center()
    }

    private func vbSaveFrame() {
        guard let savedFrameKey else { return }
        UserDefaults.standard.set(frame.dictionaryRepresentation, forKey: savedFrameKey)
        UserDefaults.standard.synchronize()
    }

}
