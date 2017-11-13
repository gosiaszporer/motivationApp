//
//  ViewController.swift
//  MotivationApp
//
//  Created by Gosia on 11/13/17.
//  Copyright © 2017 Gosia. All rights reserved.
//

import UIKit
import AVFoundation
import UserNotifications

class ViewController: UIViewController {
    
    //MARK: Properties
    var audioPlayer:AVAudioPlayer!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Actions
    
    @IBAction func tapMotivation(_ sender: UIButton) {
        let audioFilePath = Bundle.main.path(forResource: "Get_Your_Shit_Together", ofType: "wav")
        
        if audioFilePath != nil {
            
            let audioFileUrl = NSURL.fileURL(withPath: audioFilePath!)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audioFileUrl)
            } catch {
                print(error)
            }
            audioPlayer.play()
            
        } else {
            print("audio file is not found")
        }
    }
    
    @IBAction func tapNotification(_ sender: UIButton) {
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                    self.scheduleLocalNotification()
                })
            case .authorized:
                self.scheduleLocalNotification()
            case .denied:
                print("Application Not Allowed to Display Notifications")
            }
        }
    }
    
    //MARK: Private functions	
        
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            
            completionHandler(success)
        }
    }
    
    private func scheduleLocalNotification() {
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        notificationContent.title = "You know what you should do?"
        notificationContent.body = "Get your shit together! 💩"
        
        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 120.0, repeats: false)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "cocoacasts_local_notification", content: notificationContent, trigger: notificationTrigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
}

extension ViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
    
}

