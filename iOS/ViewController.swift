//
//  ViewController.swift
//  SCNSolarSystem-iOS
//
//  Created by Christophe on 27/02/2022.
//

import Foundation
import UIKit
import GameController

class ViewController : UIViewController {
    
    private var virtualController: GCVirtualController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = SolarSystemView(frame: self.view.frame)
        self.view.addSubview(view)
        
        let notificationCenter = NotificationCenter.default
        let mainQueue = OperationQueue.main
        notificationCenter.addObserver(forName: .GCControllerDidConnect, object: nil, queue: mainQueue) { notif in
            self.gameControllerDidConnect(notif.object as! GCController)
        }
        notificationCenter.addObserver(forName: .GCControllerDidDisconnect, object: nil, queue: mainQueue) { notif in
            self.gameControllerDidDisconnect()
        }
        
        setupVirtualController()
    }
    
    func setupVirtualController() {
        let configuration = GCVirtualController.Configuration()
        configuration.elements = [GCInputLeftThumbstick, GCInputButtonA]
        
        virtualController = GCVirtualController(configuration: configuration)
        if GCController.controllers().isEmpty {
            virtualController?.connect()
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override var shouldAutorotate: Bool { true }
    
    private func gameControllerDidConnect(_ controller: GCController) {
        print(controller != virtualController?.controller)
        if controller != virtualController?.controller {
            virtualController?.disconnect()
        }
    }
    
    private func gameControllerDidDisconnect() {
        if GCController.controllers().isEmpty {
            virtualController?.connect()
        }
    }
    
}
