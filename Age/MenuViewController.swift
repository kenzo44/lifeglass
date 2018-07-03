//
//  MenuViewController.swift
//  Age
//
//  Created by David Song on 6/13/18.
//  Copyright © 2018 David Song. All rights reserved.
//

import Cocoa
import ServiceManagement

class MenuViewController: NSViewController {
    @IBOutlet var datePicker: NSDatePicker!
    @IBOutlet var saveButton: NSButton!
    @IBOutlet weak var labelingButton: NSButton!
    @IBOutlet weak var launchstartButton: NSButtonCell!
    @IBOutlet weak var countdownButton: NSButtonCell!
    @IBOutlet weak var lifespanPicker: NSTextField!
    let helperBundleName = "com.davidtsong.lifeglasshelper"
    let launchOnStart = UserDefaults.standard.bool(forKey:"Labeling") ?? false
    
    override func viewDidLoad()
    {
        launchstartButton.state = launchOnStart ? .on : .off // Set Initial State based on what is in
        let birthdate = UserDefaults.standard.object(forKey: "Birthdate")
        if let birth = birthdate as? Date
        {
            datePicker.dateValue = birth

//            saveButton.isEnabled = false
        }
        let lifespan = UserDefaults.standard.object(forKey: "Lifespan")
        if let lifespanTemp = lifespan as? Int
        {
            lifespanPicker.integerValue = lifespanTemp
        }
        else
        {
            lifespanPicker.integerValue =  78
            UserDefaults.standard.set(78, forKey:"Lifespan")
        }
        let countdown = UserDefaults.standard.object(forKey: "Countdown")
        if let countdownTemp = countdown as? Bool
        {
            
            countdownButton.state = (countdownTemp) ? .on : .off
        }
        
        SMLoginItemSetEnabled(helperBundleName as CFString, launchOnStart)
        
    }
}

extension MenuViewController{
    static func freshController() -> MenuViewController {
        
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "MenuViewController")
        
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? MenuViewController else {
            fatalError("Why cant i find MenuViewController? - Check Main.storyboard")
        }
        
        
        return viewcontroller
    }

}
extension MenuViewController {
    @IBAction func quit(_sender: NSButton) {
         NSApplication.shared.terminate(_sender)
    }
    @IBAction func textLabelingToggle(_ sender:  NSButton)
    {
        let appDelegate = NSApp.delegate as! AppDelegate
        switch labelingButton.state {
            case .on:
                UserDefaults.standard.set(true, forKey:"Labeling")
            case .off:
                UserDefaults.standard.set(false, forKey:"Labeling")
            default: break
        }
        appDelegate.stopTimer()

        appDelegate.updateTimer()
    }
    @IBAction func countDownButtonToggle(_ sender:  NSButton)
    {
        let appDelegate = NSApp.delegate as! AppDelegate
        switch countdownButton.state {
            case .on:
                UserDefaults.standard.set(true, forKey:"Countdown")
            case .off:
                UserDefaults.standard.set(false, forKey:"Countdown")
            default: break
        }
        appDelegate.stopTimer()
        
        appDelegate.updateTimer()
    }
    
    @IBAction func launchToggle(_ sender: NSButton)
    {
        let isAuto = sender.state == .on
        SMLoginItemSetEnabled(helperBundleName as CFString, isAuto)
    }
    @IBAction func save(_sender: NSButton) {
        let appDelegate = NSApp.delegate as! AppDelegate
        let birthdate = datePicker.dateValue
        let lifespan = lifespanPicker.integerValue

        UserDefaults.standard.set(birthdate, forKey:"Birthdate")
        UserDefaults.standard.set(lifespan, forKey:"Lifespan")
//        saveButton.isEnabled = false
//        if(!appDelegate.timerRunning())
//        {
//            appDelegate.runTimer()
//        }
//        else
//        {
            //Stop Timer
            appDelegate.stopTimer()
            //Start Timer Need to reset birthdate value 
            appDelegate.updateTimer()
//        }
    }

}





