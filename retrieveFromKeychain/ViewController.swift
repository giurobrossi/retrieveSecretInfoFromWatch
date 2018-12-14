//
//  ViewController.swift
//  retrieveFromKeychain
//
//  Created by Rossi Giuseppe Roberto (UniCredit Business Integrated Solutions) on 14/12/18.
//  Copyright © 2018 Rossi Giuseppe Roberto (UniCredit Business Integrated Solutions). All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var switchAccessibleInfo: UISwitch!
    
    let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureWCSession()
        print("ViewController: required init")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("ViewController: viewDidLoad")
    }
    
    @IBAction func saveIntoKeychain(_ sender: Any) {
        let secretString = textField.text ?? ""
        if KeychainWrapper.standard.removeAllKeys() {
            var option: KeychainItemAccessibility
            if switchAccessibleInfo.isOn {
                option = KeychainItemAccessibility.always
            } else {
                option = KeychainItemAccessibility.whenUnlockedThisDeviceOnly
            }
            if KeychainWrapper.standard.set(secretString, forKey: "mySecretKey", withAccessibility: option) {
                print("Secret text saved")
                let alertController = UIAlertController(title: "Attenzione", message: "Secret Key '\(secretString)' Saved", preferredStyle: UIAlertController.Style.alert)
                let defaultAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                print("Error - No secret text saved")
            }
        } else {
            print("Error: keys not removed from Keychain")
        }
    }
}



extension ViewController: WCSessionDelegate
{
    /** Called when all delegate callbacks for the previously selected watch has occurred. The session can be re-activated for the now selected watch using activateSession. */
    @available(iOS 9.3, *)
    public func sessionDidDeactivate(_ session: WCSession) {
        //Dummy Implementation
        print("Session did deactivate")
        session.activate()
    }
    
    /** Called when the session can no longer be used to modify or add any new transfers and, all interactive messages will be cancelled, but delegate callbacks for background transfers can still occur. This will happen when the selected watch is being changed. */
    @available(iOS 9.3, *)
    public func sessionDidBecomeInactive(_ session: WCSession) {
        //Dummy Implementation
        print("Session did became inactive")
    }
    
    /** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
    @available(iOS 9.3, *)
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //Dummy Implementation
        print("session activation did complete")
        print("Error session not activated from iPhone side: \(String(describing: error?.localizedDescription))")
    }
    
    fileprivate func configureWCSession() {
        session?.delegate = self;
        session?.activate()
        print("ViewController: init - Session Activated on iOS")
    }
    
    // Metodo che gestisce la comunicazione
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        let toWatchOSTxt = KeychainWrapper.standard.string(forKey: "mySecretKey")
        replyHandler(["message" : toWatchOSTxt as Any])
    }
    
}

