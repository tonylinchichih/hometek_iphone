//
//  RegisterViewController.swift
//  Hometek
//
//  Created by Lai Lee on 13/08/2017.
//  Copyright © 2017 Lai Lee. All rights reserved.
//

import Foundation
import UIKit

class RegisterViewController:BaseViewController, AKRadioButtonsControllerDelegate {
    var radioButtonsController: AKRadioButtonsController!
    @IBOutlet var radioButtons: [AKRadioButton]!
    
    @IBOutlet weak var addr1: UITextField!
    @IBOutlet weak var addr2: UITextField!
    @IBOutlet weak var addr3: UITextField!
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var fcmStatusText: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var lpButton: UIButton!

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var sipImage: UIImageView!
    @IBOutlet weak var sipDisplayName: UILabel!
    @IBOutlet weak var sipAddress: UILabel!
    @IBOutlet weak var sipSwitch: UISwitch!
    @IBOutlet weak var sipServerIp: UITextField!
    var userInfo: UserInfo!
    
    @IBAction func sipSwitch(_ switchBtn: UISwitch) {
        MyUtils.enableSip(switchBtn.isOn)
    }
    
    @IBAction func onRegisterClick(_ sender: Any) {
        if addr1.text == nil || addr2.text == nil || addr3.text == nil{
            return
        }
        if !(addr1.text!.isNumber && addr2.text!.isNumber && addr3.text!.isNumber) {
            return
        }
        
        MyUtils.removeAccount()
        
        userInfo.address1 = addr1.text!
        userInfo.address2 = addr2.text!
        userInfo.address3 = addr3.text!
        userInfo.sipIp = sipServerIp.text!
        userInfo.save()
        
        let name = String(format: "%04d%02d%02d9", Int(addr1.text!)!, Int(addr2.text!)!, Int(addr3.text!)!);
        MyUtils.createAccount(name, displayName: "Hometek", domain: "192.168.10.40", pwd: name, ip: sipServerIp.text)
    }
    
    override func regState(_ state: HLinphoneRegistrationState) {
        NSLog("haha registrationUpdate: \(state)")
        updateSipInfo()
    }
    
    @IBAction func onLpClick(_ sender: Any) {
        MyUtils.goToLP()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        userInfo = UserInfo.sharedInstance();
        
        radioButtonsController = AKRadioButtonsController(radioButtons: self.radioButtons)
        radioButtonsController.delegate = self //class should implement AKRadioButtonsControllerDelegate

        addr1.text = userInfo.address1
        addr2.text = userInfo.address2
        addr3.text = userInfo.address3
        sipServerIp.text = userInfo.sipIp
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), //name:NSNotification.Name.UIResponder.keyboardWillShowNotification, object: nil)
            name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), //name:NSNotification.Name.UIResponder.keyboardWillHideNotification, object: nil)
        name:UIResponder.keyboardWillHideNotification, object: nil)
        
        //https://stackoverflow.com/questions/2824435/uiscrollview-not-scrolling
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        updateSipInfo()
        
        sipSwitch.setOn(MyUtils.isSipEnabled(), animated: false)
        #if DEBUG
        lpButton.isHidden = false
        #else
        lpButton.isHidden = true
        #endif
        
        // Do any additional setup after loading the view.
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc func appMovedToForeground() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        MyUtils.resetMissedCallsCount();
    }
    
    
    @objc func appMovedToBackground() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        MyUtils.resetMissedCallsCount();
    }
    
    private func updateSipInfo() {
        sipDisplayName.text = MyUtils.getDisplayName()
        sipAddress.text = MyUtils.getSipAddress()
        let state = MyUtils.getSipState()
        let imageName = MyUtils.image(for: state)
        sipImage.image = UIImage(named: imageName!)
        sipSwitch.setOn(MyUtils.isSipEnabled(), animated: false)
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 100
        scrollView.contentInset = contentInset//workaround
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    func selectedButton(sender: AKRadioButton){ }
}
