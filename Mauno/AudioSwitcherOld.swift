//
//  AudioSwitcherOld.swift
//  Mauno
//

import AppKit

class AudioSwitcherOld: AudioSwitcher {
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
        let bundle = Bundle(path: "/System/Library/PreferencePanes/UniversalAccessPref.prefPane")!

        let klass = bundle.classNamed("UniversalAccessPref") as! NSObject.Type
        let universalAccessPref = klass.init()

        let secondClass = bundle.classNamed("UAPAudioViewController") as! NSObject.Type
        var audioViewController = secondClass.perform(NSSelectorFromString("alloc"))!.takeUnretainedValue() as! NSObject
        audioViewController = audioViewController.perform(
            NSSelectorFromString("initWithUAPref:"),
            with: universalAccessPref
        )?.takeUnretainedValue() as! NSObject

        self.audioViewController = audioViewController

        button = NSButton()
        button.identifier = NSUserInterfaceItemIdentifier("_NS:12")
    }
}
