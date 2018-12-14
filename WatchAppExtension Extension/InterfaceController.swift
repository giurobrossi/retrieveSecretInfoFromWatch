//
//  InterfaceController.swift
//  WatchAppExtension Extension
//
//  Created by Rossi Giuseppe Roberto (UniCredit Business Integrated Solutions) on 14/12/18.
//  Copyright © 2018 Rossi Giuseppe Roberto (UniCredit Business Integrated Solutions). All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController {
    
    private let session : WCSession? = WCSession.isSupported() ? WCSession.default : nil
    @IBOutlet weak var labelSecretStuffFromiOSKeychain: WKInterfaceLabel!
    
    @IBAction func retrieveSecretDataFromKeychain() {
        self.labelSecretStuffFromiOSKeychain.setText("")
        let messaggioDict = ["message":"actionRetrieveDataFromKeychain"]
        // The paired iPhone has to be connected via Bluetooth.
        if let session = session, session.isReachable {
            session.sendMessage(messaggioDict, replyHandler: { replyMessage in
                // handle reply from iPhone app here
                let replyMessageFromiOS = replyMessage["message"] as? String
                DispatchQueue.main.async {
                    self.labelSecretStuffFromiOSKeychain.setText(replyMessageFromiOS)
                }
            },
            errorHandler: { error in
                // catch any errors here
                print("Send Message Error: \(error.localizedDescription)")
            })
        } else {
            // when the iPhone is not connected via Bluetooth
            print("iPhone non connesso via BlueTooth")
        }
    }
    
    override init() {
        super.init()
        configureSession()
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("InterfaceController awake")
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        print("InterfaceController willActivate")
    }
    
    override func didAppear() {
        super.didAppear()
        print("InterfaceController didAppear")
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        print("InterfaceController didDeactivate")
    }
}


extension InterfaceController: WCSessionDelegate {
    /** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
    @available(watchOS 2.2, *)
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //Dummy Implementation
        guard (error != nil) else {
            print("Session not Activated from Watch Side: \(String(describing: error?.localizedDescription))")
            session.activate()
            return
        }
    }
    
private func configureSession() {
        session?.delegate = self
        session?.activate() // SINCRONO fino a WATCHOS 2.0
        print("InterfaceController init: Session Activated")
    }
}

