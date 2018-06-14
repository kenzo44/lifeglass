//
//  AppDelegate.swift
//  Age
//
//  Created by David Song on 6/13/18.
//  Copyright © 2018 David Song. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let popover = NSPopover()
    var eventMonitor: EventMonitor?
    var timer:Timer?
    var birth: Date!
    var birthdayexists = false

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if let button = statusItem.button {
//            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
            var birthdate = UserDefaults.standard.object(forKey: "Birthdate")
            if let birthTemp = birthdate as? Date //Initializes the birth Date object
            {
                birth = birthTemp
                birthdayexists = true
                runTimer()
                //Start if bday already exists
            }
            else
            {
                button.title = "Click Here and Set Birthdate" // No birthdate found, then replace with default blank
            }
            button.action = #selector(togglePopover(_:))
        }
        
        popover.contentViewController = MenuViewController.freshController()
        
        //Start Countdown / CountUp
        
        
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let strongSelf = self, strongSelf.popover.isShown {
                strongSelf.closePopover(sender: event)
            }
        }
    }
    func updateTimer()
    {
        var birthdate = UserDefaults.standard.object(forKey: "Birthdate")
        if let birthTemp = birthdate as? Date //Initializes the birth Date object
        {
            birth = birthTemp
            birthdayexists = true
            runTimer()
            //Start if bday already exists
        }
    }
    func timerRunning() -> Bool
    {
        return (timer !== nil)
    }
    func runTimer()
    {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(Counting), userInfo: nil, repeats: true)
    }
    func stopTimer()
    {
        timer?.invalidate()
    }
    @objc func Counting()
    {
        //Approach #2 to calculating the difference in time
        var calendar = Calendar.current
        var times = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from:birth, to:Date())
        
        //Approach #1 to calculating the difference in time
        //            let interval = Int(birth.timeIntervalSinceNow) * -1
        //            let years = interval / 31536000
        //            let months = (interval % 31536000) / 2628000
        //            let days = (interval % 31536000 % 2628000) / 86400
        //            let hours = (interval % 31536000 % 2628000 % 86400) / 3600
        //            let minutes = (interval % 31536000 % 2628000 % 86400 % 3600) / 60
        //            let seconds = (interval % 31536000 % 2628000 % 86400 % 3600 % 60)
        //            statusItem.button?.title = "\(years)y:\(months)m:\(days)d:\(hours)h:\(minutes)m:\(seconds)s"
        if(UserDefaults.standard.bool(forKey:"Labeling"))
        {
        statusItem.button?.title = "\(times.year!)y:\(times.month!)m:\(times.day!)d:\(times.hour!)h:\(times.minute!)m:\(times.second!)s"
        }
        else
        {
            statusItem.button?.title = "\(times.year!):\(times.month!):\(times.day!):\(times.hour!):\(times.minute!):\(times.second!)"
        }
        
        

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        
        eventMonitor?.start()
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }

}

