//
//  MainViewController.swift
//  linphone
//
//  Created by Lai Lee on 2020/7/9.
//

import UIKit

class MainViewController:UIViewController, UITextFieldDelegate, UICompositeViewDelegate {

    let _storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    @IBAction func settingTouchDown(_ sender: Any) {
        self._present("register_view")
    }
    
    @IBAction func securityTouchDown(_ sender: Any) {
        self._present("security_view")
    }
    
    @IBAction func remoteTouchDown(_ sender: Any) {
        self._present("remote_control_view")
    }
    @IBAction func notifyTouchDown(_ sender: Any) {
        self._present("AlertsTableViewController")
    }
    
    private func _present(_ name: String) {
        let vc = _storyboard.instantiateViewController(withIdentifier: name)
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
    
    static func compositeViewDescription() -> UICompositeViewDescription! {
        if compositeDescription == nil {
            compositeDescription = UICompositeViewDescription(
                       object_getClass(self)
                           , statusBar: nil
                           , tabBar: nil
                           , sideMenu: nil
                          , fullscreen:false
                          , isLeftFragment: true
                          , fragmentWith:nil)
        }
        compositeDescription!.darkBackground = false;
        compositeDescription!.landscapeMode = false;
        return compositeDescription;
    }
    
    func compositeViewDescription() -> UICompositeViewDescription! {
        if MainViewController.compositeDescription == nil {
            MainViewController.compositeDescription = UICompositeViewDescription(
            object_getClass(self)
                , statusBar: nil
                , tabBar: nil
                , sideMenu: nil
               , fullscreen:false
               , isLeftFragment: true
               , fragmentWith:nil)
        }
        MainViewController.self.compositeDescription?.landscapeMode = false;
        return MainViewController.self.compositeDescription;
    }

    static var compositeDescription:UICompositeViewDescription? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(receiveTest(_:)), name: NSNotification.Name("TestNotification"), object: nil)
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    @objc func appMovedToForeground() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        MyUtils.resetMissedCallsCount();
    }
    
    
    @objc func appMovedToBackground() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        MyUtils.resetMissedCallsCount();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveTest(_:)), name: NSNotification.Name("TestNotification"), object: nil)
        if MyUtils.isUserTapped() == true {
            print("test AlertsTableViewController!!!!!")
            self._present("AlertsTableViewController")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("viewDidDisappear")
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    @objc func receiveTest(_ notification: Notification?) {
        // [notification name] should always be @"TestNotification"
        // unless you use this method for observation of other notifications
        // as well.
        print("test MainViewController receiveTest...")
        if (notification?.name.rawValue)! == "TestNotification" {
            MyUtils.isUserTapped() //reset flag
            self._present("AlertsTableViewController")
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
}
