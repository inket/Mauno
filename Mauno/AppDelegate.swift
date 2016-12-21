//
//  AppDelegate.swift
//  Mauno
//

import AppKit

extension NSImage {
    func tint(color: NSColor) -> NSImage {
        return NSImage(size: size, flipped: false) { (rect) -> Bool in
            color.set()
            rect.fill()
            self.draw(in: rect, from: NSRect(origin: .zero, size: self.size), operation: .destinationIn, fraction: 1.0)
            return true
        }
    }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let audioSwitcher = AudioSwitcher()

    let statusItem = NSStatusBar.system.statusItem(withLength: 18)
    let monoStatusMenuItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
    let switchMenuItem = NSMenuItem(title: "", action: #selector(switchAudio), keyEquivalent: "")
    let switchToMonoOnStartMenuItem  = NSMenuItem(
        title: "Switch to Mono when launching Mauno",
        action: #selector(toggleSwitchOnAppStartPreference),
        keyEquivalent: ""
    )
    let switchDisplayRedIconMenuItem = NSMenuItem(
        title: "Use red icon when set to Mono",
        action: #selector(toggleDisplayRedIconPreference),
        keyEquivalent: ""
    )

    var switchToMonoOnStart: Bool {
        get {
            UserDefaults.standard.bool(forKey: "switchToMonoOnStart")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "switchToMonoOnStart")
        }
    }

    var displayRedIcon: Bool {
        get {
            UserDefaults.standard.bool(forKey: "displayRedIcon")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "displayRedIcon")
        }
    }

    var useMonoAudio: Bool = false {
        didSet {
            if useMonoAudio {
                var singleSpeakerImage = NSImage(named: "hifispeaker.fill")
                if displayRedIcon {
                    singleSpeakerImage = singleSpeakerImage?.tint(
                        color: NSColor(calibratedRed: 1, green: 0.3, blue: 0.3, alpha: 1)
                    )
                }

                statusItem.image = singleSpeakerImage
                monoStatusMenuItem.title = "Playing in Mono"
                switchMenuItem.title = "Switch to Stereo"
            } else {
                statusItem.image = NSImage(named: "hifispeaker.2.fill")
                monoStatusMenuItem.title = "Playing in Stereo"
                switchMenuItem.title = "Switch to Mono"
            }

            audioSwitcher.useMonoAudio = useMonoAudio
        }
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        UserDefaults.standard.register(defaults: [
            "displayRedIcon": true
        ])

        statusItem.toolTip = "Mauno"

        let menu = NSMenu(title: "Mauno")
        statusItem.menu = menu
        menu.items = [
            monoStatusMenuItem,
            switchMenuItem,
            NSMenuItem.separator(),
            switchToMonoOnStartMenuItem,
            switchDisplayRedIconMenuItem,
            NSMenuItem.separator(),
            NSMenuItem(title: "GitHub…", action: #selector(openGitHub), keyEquivalent: ""),
            NSMenuItem.separator(),
            NSMenuItem(title: "Quit", action: #selector(NSApp.terminate(_:)), keyEquivalent: "Q")
        ]

        switchToMonoOnStartMenuItem.state = switchToMonoOnStart ? .on : .off
        switchDisplayRedIconMenuItem.state = displayRedIcon ? .on : .off
        useMonoAudio = switchToMonoOnStart
    }

    func applicationWillTerminate(_ notification: Notification) {
        useMonoAudio = false
    }

    @objc private func switchAudio() {
        useMonoAudio = !useMonoAudio
    }

    @objc private func toggleSwitchOnAppStartPreference() {
        switchToMonoOnStart = !switchToMonoOnStart
        switchToMonoOnStartMenuItem.state = switchToMonoOnStart ? .on : .off
    }

    @objc private func toggleDisplayRedIconPreference() {
        displayRedIcon = !displayRedIcon
        switchDisplayRedIconMenuItem.state = displayRedIcon ? .on : .off

        if useMonoAudio {
            var singleSpeakerImage = NSImage(named: "hifispeaker.fill")
            if displayRedIcon {
                singleSpeakerImage = singleSpeakerImage?.tint(
                    color: NSColor(calibratedRed: 1, green: 0.3, blue: 0.3, alpha: 1)
                )
            }
            statusItem.image = singleSpeakerImage
        }
    }

    @objc private func openGitHub() {
        NSWorkspace.shared.open(URL(string: "https://github.com/inket/Mauno")!)
    }
}
