//
//  AppDelegate.swift
//  ApacheManager
//
//  Created by Marcel Eschmann on 11/04/15.
//  Copyright (c) 2015 Marcel Eschmann. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var ApacheMenu: NSMenu!
    @IBOutlet weak var toggleMenuItem: NSMenuItem!
    @IBOutlet weak var restartMenuItem: NSMenuItem!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    let visibleIcon = NSImage(named: "visibleIcon")
    let invisibleIcon = NSImage(named: "invisibleIcon")
    
    var apacheIsRunning = false

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        ApacheMenu.autoenablesItems = false
        
        visibleIcon?.setTemplate(true)
        invisibleIcon?.setTemplate(true)
        
        statusItem.image = invisibleIcon
        statusItem.menu = ApacheMenu
    }

    @IBAction func exitApp(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func toggleApacheAction(sender: NSMenuItem) {
        let task = NSTask()
        task.launchPath = "/usr/sbin/apachectl"
        
        if (apacheIsRunning) {
            // sudo apachectl stop
            if (!self.executeShellCommand("do shell script \"sudo apachectl stop\" with administrator privileges")) {
                //return
            }
            
            apacheIsRunning = false
            sender.title = "Start Apache"
            statusItem.image = invisibleIcon
            restartMenuItem.enabled = false
        }else {
            // sudo apachectl start
            if (!self.executeShellCommand("do shell script \"sudo apachectl start\" with administrator privileges")) {
                //return
            }
            
            apacheIsRunning = true
            sender.title = "Stop Apache"
            statusItem.image = visibleIcon
            restartMenuItem.enabled = true
        }
    }
    
    @IBAction func restartApacheAction(sender: NSMenuItem) {
        // sudo apachectl restart
        self.executeShellCommand("do shell script \"sudo apachectl restart\" with administrator privileges")
    }
    
    func executeShellCommand(command: String) -> Bool {
        let script = NSAppleScript(source: command)
        var result = script?.executeAndReturnError(nil)
        if (result != nil) {
            return false
        }
        
        return true
    }
}

