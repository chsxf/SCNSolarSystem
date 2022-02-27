//
//  Rocket.swift
//  SCNSolarSystem
//
//  Created by Christophe SAUVEUR on 02/01/2022.
//

import SceneKit
import SceneKit.ModelIO
import GameController
import SpriteKit

class Rocket : NSResponder {
    
    fileprivate let EXHAUST_LIGHT_INTENSITY: CGFloat = 2000
    
    let rocketRootNode: SCNNode
    let cameraNode: SCNNode
    let exhaustLight: SCNLight
    let exhaustParticleSystem: SCNParticleSystem
    let initialExhaustParticlesBirthRate: CGFloat
    
    var stickXValue: Float = 0
    var stickYValue: Float = 0
    
    var engineStarted: Bool = false
    
    init(inScene scene: SCNScene, withMaxAphelion maxAphelion: Float) {
        let url = Bundle.main.url(forResource: "Toy_rocket", withExtension: "usdz")!
        let asset = MDLAsset(url: url)
        let rocketNode = SCNNode(mdlObject: asset.object(at: 0))
        rocketNode.eulerAngles = SCNVector3(Float.pi / 2, 0, Float.pi)
        
        Rocket.changeMaterialsLightingModelRecursively(node: rocketNode)
        
        rocketRootNode = SCNNode()
        rocketRootNode.position = SCNVector3(0, 0, -maxAphelion * 1.5)
        rocketRootNode.addChildNode(rocketNode)
        scene.rootNode.addChildNode(rocketRootNode)
        
        let rocketNodeBaseLight = SCNLight()
        rocketNodeBaseLight.type = .omni
        rocketNodeBaseLight.intensity = 100
        let rocketNodeBaseLightNode = SCNNode()
        rocketNodeBaseLightNode.light = rocketNodeBaseLight
        rocketRootNode.addChildNode(rocketNodeBaseLightNode)
        rocketNodeBaseLightNode.position = SCNVector3(0, 100, -200)
        
        exhaustLight = SCNLight()
        exhaustLight.type = .omni
        exhaustLight.color = NSColor.orange
        exhaustLight.attenuationEndDistance = 300
        exhaustLight.attenuationStartDistance = 50
        exhaustLight.intensity = 0
        let exhaustLightNode = SCNNode()
        exhaustLightNode.light = exhaustLight
        rocketRootNode.addChildNode(exhaustLightNode)
        exhaustLightNode.position = SCNVector3(0, 0, -100)
        
        let particleSceneURL = Bundle.main.url(forResource: "ExhaustParticles", withExtension: "scn")
        let particleScene = try? SCNScene(url: particleSceneURL!, options: nil)
        let particleNode = particleScene!.rootNode.childNode(withName: "particles", recursively: true)!
        rocketRootNode.addChildNode(particleNode)
        exhaustParticleSystem = particleNode.particleSystems![0]
        exhaustParticleSystem.particleImage = "smoke"
        initialExhaustParticlesBirthRate = exhaustParticleSystem.birthRate
        
        let camera = SCNCamera()
        camera.zNear = 1
        camera.zFar = Double(maxAphelion) * 3
        cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(0, 100, -200)
        cameraNode.eulerAngles = SCNVector3(0, Float.pi, 0)
        rocketRootNode.addChildNode(cameraNode)
        
        super.init()
        
        disableEngine()
        
        let notificationCenter = NotificationCenter.default
        let mainQueue = OperationQueue.main
        notificationCenter.addObserver(forName: .GCControllerDidConnect, object: nil, queue: mainQueue) { notif in
            self.gameControllerDidConnect(notif.object as! GCController)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate static func changeMaterialsLightingModelRecursively(node: SCNNode) {
        let geometry = node.geometry
        if geometry != nil {
            for material in geometry!.materials {
                material.lightingModel = .blinn
            }
        }
        
        for child in node.childNodes {
            changeMaterialsLightingModelRecursively(node: child)
        }
    }
    
    func enableEngine() {
        exhaustLight.intensity = EXHAUST_LIGHT_INTENSITY
        exhaustParticleSystem.birthRate = initialExhaustParticlesBirthRate
        engineStarted = true
    }
    
    func disableEngine() {
        exhaustLight.intensity = 0
        exhaustParticleSystem.birthRate = 0
        engineStarted = false
    }
    
    func registerExtendedGamepad(_ gamepad: GCExtendedGamepad) {
        
    }
    
    private func gameControllerDidConnect(_ controller: GCController) {
        guard let extendedPad = controller.extendedGamepad else {
            print("Extended gamepad not found")
            return
        }
        
        extendedPad.buttonA.pressedChangedHandler = onAButtonValueChanged(buttonInput:pressure:pressed:)
        extendedPad.buttonB.pressedChangedHandler = onBButtonValueChanged(buttonInput:pressure:pressed:)
        extendedPad.leftThumbstick.valueChangedHandler = onLeftThumpstickValueChanged(directionPad:xValue:yValue:)
    }
    
    private func onAButtonValueChanged(buttonInput: GCControllerButtonInput, pressure: Float, pressed: Bool) {
        updateEngineStatus(enabled: pressed)
    }
    
    private func onBButtonValueChanged(buttonInput: GCControllerButtonInput, pressure: Float, pressed: Bool) {
        
    }
    
    func updateEngineStatus(enabled: Bool) {
        if enabled {
            enableEngine()
        }
        else {
            disableEngine()
        }
    }
    
    private func onLeftThumpstickValueChanged(directionPad: GCControllerDirectionPad, xValue: Float, yValue: Float) {
        updateDirections(xValue: xValue, yValue: yValue)
    }
    
    func updateDirections(xValue: Float, yValue: Float) {
        stickXValue = xValue
        stickYValue = yValue
    }
    
    func update(deltaTime: TimeInterval) {
        let angle = (Float.pi / 3.0) * -stickXValue * Float(deltaTime)
        let quatRotation = simd_quatf(angle: angle, axis: simd_float3(x: 0, y: 1, z: 0))
        rocketRootNode.rotate(by: SCNQuaternion(quatRotation.vector), aroundTarget: rocketRootNode.position)
        
        rocketRootNode.localTranslate(by: SCNVector3(x: 0, y: 10000.0 * CGFloat(stickYValue) * CGFloat(deltaTime), z: 0))
        
        if engineStarted {
            rocketRootNode.localTranslate(by: SCNVector3(x: 0, y: 0, z: 25000.0 * CGFloat(deltaTime)))
        }
    }
    
    override func keyUp(with event: NSEvent) {
        switch Keycode(rawValue: event.keyCode)! {
        case Keycode.space:
            updateEngineStatus(enabled: false)
            break
        case .upArrow:
            updateDirections(xValue: stickXValue, yValue: stickYValue - 1)
            break
        case .downArrow:
            updateDirections(xValue: stickXValue, yValue: stickYValue + 1)
            break
        case .leftArrow:
            updateDirections(xValue: stickXValue + 1, yValue: stickYValue)
            break
        case .rightArrow:
            updateDirections(xValue: stickXValue - 1, yValue: stickYValue)
            break
        default:
            break
        }
    }
    
    override func keyDown(with event: NSEvent) {
        if event.isARepeat {
            return
        }
        
        switch Keycode(rawValue: event.keyCode)! {
        case .space:
            updateEngineStatus(enabled: true)
            break
        case .upArrow:
            updateDirections(xValue: stickXValue, yValue: stickYValue + 1)
            break
        case .downArrow:
            updateDirections(xValue: stickXValue, yValue: stickYValue - 1)
            break
        case .leftArrow:
            updateDirections(xValue: stickXValue - 1, yValue: stickYValue)
            break
        case .rightArrow:
            updateDirections(xValue: stickXValue + 1, yValue: stickYValue)
            break
        default:
            break
        }
    }
}
