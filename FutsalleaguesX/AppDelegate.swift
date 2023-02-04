//
//  AppDelegate.swift
//  FutsalleaguesX
//
//  Created by macOS on 02/02/23.
//

import UIKit
import AVKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var Id = "1526"
    var SelectedLeague = ""
    var appNavigation:UINavigationController?
    var player:AVAudioPlayer?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.initialVC()
        return true
    }
    
    //MARK: - InitialVC Method
    func initialVC() {
        APP_DELEGATE.appNavigation = UINavigationController(rootViewController: loadVC(strStoryboardId: SB_MAIN, strVCId: idViewController))
        APP_DELEGATE.appNavigation?.isNavigationBarHidden = true
        APP_DELEGATE.window?.rootViewController = APP_DELEGATE.appNavigation
        self.playBGAudio(isStop: false)
    }
    
    func playBGAudio(isStop:Bool) {
        if let path = Bundle.main.path(forResource: "bg", ofType: "mp3") {
            let filePath = NSURL(fileURLWithPath:path)
            self.player = try! AVAudioPlayer.init(contentsOf: filePath as URL)
            self.player?.numberOfLoops = -1 //logic for infinite loop
            self.player?.prepareToPlay()
            if isStop {
                self.player?.stop()
            } else {
                self.player?.play()
            }
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try!audioSession.setCategory(AVAudioSession.Category.playback, options: .mixWithOthers)
    }
}

