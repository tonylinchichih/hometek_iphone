//
//  BaseViewController.swift
//  linphone
//
//  Created by Lai Lee on 2020/7/11.
//

import UIKit
import linphonesw

public enum HLinphoneRegistrationState:Int
{
    case LinphoneRegistrationNone = 0 /**< Initial state for registrations */
    case LinphoneRegistrationProgress = 1 /**< Registration is in progress */
    case LinphoneRegistrationOk = 2 /**< Registration is successful */
    case LinphoneRegistrationCleared = 3 /**< Unregistration succeeded */
    case LinphoneRegistrationFailed = 4 /**< Registration failed */
}

class BaseViewController: UIViewController {

    @IBOutlet weak var titleBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if titleBar != nil {
            titleBar.leftBarButtonItem = UIBarButtonItem(title: "上一頁", style: .plain, target: self, action: #selector(backTapped))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.callUpdate),
            name: NSNotification.Name(rawValue: "LinphoneCallUpdate"),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.registrationUpdateEvent),
            name: NSNotification.Name(rawValue: "LinphoneRegistrationUpdate"),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.configureStateUpdateEvent),
            name: NSNotification.Name(rawValue: "LinphoneConfiguringStateUpdate"),
            object: nil)
                
        //        NotificationCenter.default.addObserver(
        //            self,
        //            selector: #selector(self.callUpdate),
        ////            name: NSNotification.Name(rawValue: kLinphoneMessageReceived),
        //            name: NSNotification.Name(rawValue: "LinphoneMessageReceived"),
        //            object: nil)
                
        //        NotificationCenter.default.addObserver(
        //            self,
        //            selector: #selector(self.callUpdate),
        ////            name: NSNotification.Name(rawValue: kLinphoneGlobalStateUpdate),
        //            name: NSNotification.Name(rawValue: "LinphoneGlobalStateUpdate"),
        //            object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func callUpdate(notif : NSNotification) {
        if let val = notif.userInfo?["state"] {
            var callState = Call.State(rawValue: Int(val as! NSNumber))!
            NSLog("callState: \(callState)")
            
            if (callState == .IncomingReceived) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func registrationUpdateEvent(notif : NSNotification) {
        if let val = notif.userInfo?["state"] {
//            let state = val as! NSNumber
            let state = HLinphoneRegistrationState(rawValue: Int(val as! NSNumber))!
            regState(state)
            //Log.directLog(BCTBX_LOG_DEBUG, text: "registrationUpdate: \(state)")
//            var state = val as! LinphoneRegistrationState
//            registrationUpdate(state)
//            MyUtils.foo2();
        }
        
        if let val = notif.userInfo?["message"] {
//            var state = val as! LinphoneRegistrationState

        }
    }
    
    func regState(_ state: HLinphoneRegistrationState) {
        NSLog("registrationUpdate: \(state)")
    }
    
    @objc func configureStateUpdateEvent(notif : NSNotification) {
        if let val = notif.userInfo?["state"] {
//            let state = val as! LinphoneConfiguringState
//            Log.directLog(BCTBX_LOG_DEBUG, text: "configureStateUpdateEvent: \(state)")
        }
        
    }
    
    @objc func backTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(receiveTest(_:)), name: NSNotification.Name("TestNotification"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func receiveTest(_ notification: Notification?) {
        // [notification name] should always be @"TestNotification"
        // unless you use this method for observation of other notifications
        // as well.
        if (notification?.name.rawValue)! == "TestNotification" {
            self._present("AlertsTableViewController")
        }
    }
    
    private func _present(_ name: String) {
        let _storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = _storyboard.instantiateViewController(withIdentifier: name)
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
}
