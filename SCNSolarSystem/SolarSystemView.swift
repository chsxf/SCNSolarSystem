//
//  SolarSystemView.swift
//  SCNSolarSystem
//
//  Created by Christophe SAUVEUR on 13/12/2021.
//

import SceneKit
import SpriteKit

class SolarSystemView: SCNView, SCNSceneRendererDelegate {
    
    private let sphereNode: SCNNode
    
    private var lastTime: TimeInterval?
    
    override init(frame frameRect: NSRect, options: [String : Any]? = nil) {
        let earthMaterial = SCNMaterial()
        earthMaterial.diffuse.contents = "Earth"
        earthMaterial.specular.contents = "Earth_specular"
        earthMaterial.normal.contents = "Earth_normal"
        
        let sphere = SCNSphere(radius: 1)
        sphere.segmentCount = 48
        sphere.firstMaterial = earthMaterial
        sphereNode = SCNNode(geometry: sphere)
        
        super.init(frame: frameRect, options: options)
        
        delegate = self
        
        showsStatistics = true
        allowsCameraControl = true
        rendersContinuously = true
        preferredFramesPerSecond = 30
        
        let scene = SCNScene()
        self.scene = scene

        scene.background.contents = "MilkyWay"
        
        scene.rootNode.addChildNode(sphereNode)
        
        let light = SCNLight()
        light.type = .omni
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(-100, 0, 0)
        scene.rootNode.addChildNode(lightNode)
        
        let sunMaterial = SCNMaterial()
        sunMaterial.diffuse.contents = "Sun"
        sunMaterial.lightingModel = .constant
        
        let sun = SCNSphere(radius: 10)
        sun.segmentCount = 48
        sun.firstMaterial = sunMaterial
        let sunNode = SCNNode(geometry: sun)
        sunNode.position = lightNode.position
        scene.rootNode.addChildNode(sunNode)
        
        let camera = SCNCamera()
        camera.zFar = 1000
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(5, 0, 3)
        cameraNode.constraints = [SCNLookAtConstraint(target: sunNode)]
        scene.rootNode.addChildNode(cameraNode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let lastTime = lastTime else {
            lastTime = time
            return
        }
        
        let diff = time - lastTime
        self.lastTime = time
        var euler = sphereNode.eulerAngles
        euler.y += diff
        sphereNode.eulerAngles = euler
    }
    
}
