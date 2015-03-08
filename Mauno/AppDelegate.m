//
//  AppDelegate.m
//  Mauno
//
//  Created by Mahdi Bchetnia on 11/08/2012.
//  Copyright (c) 2012 Mahdi Bchetnia. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:18];
    [statusItem setImage:[NSImage imageNamed:@"status"]];
    [statusItem setToolTip:@"Mauno"];
    [statusItem setTarget:NSApp];
    [statusItem setAction:@selector(terminate:)];
    
    [self setMonoAudio:YES];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    [self setMonoAudio:NO];
}

- (void)setMonoAudio:(BOOL)val {
    NSBundle* bundle = [NSBundle bundleWithPath:@"/System/Library/PreferencePanes/UniversalAccessPref.prefPane"];
    Class class = [bundle classNamed:@"UniversalAccessPref"];
    id universalAccessPref = [[class alloc] init];
    
    class = [bundle classNamed:@"UAPAudioViewController"];
    id object = [[class alloc] performSelector:@selector(initWithUAPref:) withObject:universalAccessPref];
    
    NSButton* button = [[NSButton alloc] init];
    [button setIdentifier:@"_NS:12"];
    [button setState:val];
    
    [AppDelegate set:object name:@"_monoAudioCheckbox" val:button];
    
    objc_msgSend(object, @selector(playStereoAudioAsMono:), button);
}

+ (void)set:(id)obj name:(NSString*)name val:(id)val {
    object_setIvar(obj, class_getInstanceVariable([obj class], [name cStringUsingEncoding:NSUTF8StringEncoding]), val);
}

@end
