//
//  AudioSwitcherSonoma.swift
//  Mauno
//

import AppKit

extension NSObject {
    @objc
    func isSwiftUIReadyForProduction() -> Bool {
        false
    }
}

class AudioSwitcherSonoma: AudioSwitcher {
    private let audioViewController: NSObject
    private let button: NSButton

    var useMonoAudio: Bool = false {
        didSet {
            button.state = useMonoAudio ? .on : .off

            audioViewController.setValue(button, forKey: "_monoAudioCheckbox")
            audioViewController.perform(NSSelectorFromString("playStereoAudioAsMono:"), with: button)
        }
    }

    init() {
        // Loading the bundle directly doesn't work anymore so we have to use dlopen first
        dlopen("/System/Library/ExtensionKit/Extensions/AccessibilitySettingsExtension.appex/Contents/MacOS/AccessibilitySettingsExtension", RTLD_NOW)
        let bundle = Bundle(path: "/System/Library/ExtensionKit/Extensions/AccessibilitySettingsExtension.appex")!

        let secondClass = bundle.classNamed("UAPAudioViewController") as! NSObject.Type
        var audioViewController = secondClass.perform(NSSelectorFromString("alloc"))!.takeUnretainedValue() as! NSObject
        audioViewController = audioViewController.perform(NSSelectorFromString("init"))?.takeUnretainedValue() as! NSObject
        self.audioViewController = audioViewController

        // Use the old code path by telling it we're not using SwiftUI :D
        let originalMethod = class_getInstanceMethod(secondClass, NSSelectorFromString("useSwiftUI"))
        let swizzledMethod = class_getInstanceMethod(secondClass, NSSelectorFromString("isSwiftUIReadyForProduction"))
        method_exchangeImplementations(originalMethod!, swizzledMethod!)

        button = NSButton()
        button.identifier = NSUserInterfaceItemIdentifier("_NS:12")
    }
}
