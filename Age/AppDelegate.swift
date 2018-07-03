//
//  AppDelegate.swift
//  Age
//
//  Created by David Song on 6/13/18.
//  Copyright © 2018 David Song. All rights reserved.
//

import Cocoa
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: 120)
    
    let popover = NSPopover()
    var eventMonitor: EventMonitor?
    var timer:Timer?
    var birth: Date!
    var birthdayexists = false

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if let button = statusItem.button {
//            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
            let birthdate = UserDefaults.standard.object(forKey: "Birthdate")
            if let birthTemp = birthdate as? Date //Initializes the birth Date object
            {
                birth = birthTemp
                birthdayexists = true
                runTimer()
                //Start if bday already exists
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
        }
    }
    func timerRunning() -> Bool
    {
        return (timer !== nil)
    }
    func runTimer()
    {
        if(UserDefaults.standard.bool(forKey: "Countdown"))
        {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CountingDown), userInfo: nil, repeats: true)
        }
        else
        {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(Counting), userInfo: nil, repeats: true)
        }
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
 
        if(UserDefaults.standard.bool(forKey:"Labeling"))
        {
            statusItem.button?.title = "\(times.year!)y:\(times.month!)m:\(times.day!)d:\(times.hour!)h:\(times.minute!)m:\(times.second!)s"
            statusItem.length = 190
        }
        else
        {
            statusItem.button?.title = "\(times.year!):\(times.month!):\(times.day!):\(times.hour!):\(times.minute!):\(times.second!)"
            statusItem.length = 120
        }
    }
    @objc func CountingDown()
    {
        let calendar = Calendar.current
        let lifespan = UserDefaults.standard.integer(forKey: "Lifespan")
        var timeInterval = DateComponents()
        timeInterval.year = lifespan
        let deathYear = calendar.date(byAdding: timeInterval, to: birth)!
        var age = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from:Date(), to:deathYear)
        
        
        if(UserDefaults.standard.bool(forKey:"Labeling"))
        {
            statusItem.button?.title = "\(age.year!)y:\(age.month!)m:\(age.day!)d:\(age.hour!)h:\(age.minute!)m:\(age.second!)s"
            statusItem.length = 170
        }
        else
        {
            statusItem.button?.title = "\(age.year!):\(age.month!):\(age.day!):\(age.hour!):\(age.minute!):\(age.second!)"
            statusItem.length = 120
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

