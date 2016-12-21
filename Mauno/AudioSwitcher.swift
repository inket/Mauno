//
//  AudioSwitcher.swift
//  Mauno
//

import AppKit

class AudioSwitcher {
    private let uapAudioViewController: NSObject
    private let button: NSButton

    var useMonoAudio: Bool = false {
        didSet {
            button.state = useMonoAudio ? .on : .off

            uapAudioViewController.setValue(button, forKey: "_monoAudioCheckbox")
            uapAudioViewController.perform(NSSelectorFromString("playStereoAudioAsMono:"), with: button)
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

        uapAudioViewController = audioViewController

        button = NSButton()
        button.identifier = NSUserInterfaceItemIdentifier("_NS:12")
    }
}
