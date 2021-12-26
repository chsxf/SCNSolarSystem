//
//  SolarSystemView.swift
//  SCNSolarSystem
//
//  Created by Christophe SAUVEUR on 13/12/2021.
//

import SceneKit
import SpriteKit

class SolarSystemView: SCNView, SCNSceneRendererDelegate {
    
    private var lastTime: TimeInterval?
    
    override init(frame frameRect: NSRect, options: [String : Any]? = nil) {
        super.init(frame: frameRect, options: options)
        
        delegate = self
        
        showsStatistics = true
        allowsCameraControl = true
        rendersContinuously = true
        preferredFramesPerSecond = 30
        
        let description: SolarSystemDescription = Functions.load("data.json")
        
        let scene = SCNScene()
        self.scene = scene

        scene.background.contents = description.backgroundTexture
        
        let sun = createSphere(withRadius: description.sun.radius, lightingModel: .constant, texture: description.sun.texture)
        sun.name = "Sun"
        scene.rootNode.addChildNode(sun)
        
        let light = SCNLight()
        light.type = .omni
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = sun.position
        scene.rootNode.addChildNode(lightNode)
        
        for stellarObject in description.stellarObjects {
            let node = createSphere(withRadius: stellarObject.radius, lightingModel: .blinn, texture: stellarObject.texture, additionalTextures: stellarObject.additionalTextures)
            node.position = SCNVector3(stellarObject.distanceFromSun, 0, 0)
            node.name = stellarObject.name
            scene.rootNode.addChildNode(node)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSphere(withRadius radius: Float, lightingModel: SCNMaterial.LightingModel, texture: String, additionalTextures: AdditionalTexturesDescription? = nil) -> SCNNode {
        let material = SCNMaterial()
        material.diffuse.contents = texture
        material.lightingModel = lightingModel
        if additionalTextures?.normal != nil {
            material.normal.contents = additionalTextures!.normal!
        }
        if additionalTextures?.specular != nil {
            material.specular.contents = additionalTextures!.specular!
        }
        
        let sphere = SCNSphere(radius: CGFloat(radius))
        sphere.segmentCount = 48
        sphere.firstMaterial = material
        
        let node = SCNNode(geometry: sphere)
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let lastTime = lastTime else {
            lastTime = time
            return
        }
        
        let diff = time - lastTime
        self.lastTime = time
//        var euler = sphereNode.eulerAngles
//        euler.y += diff
//        sphereNode.eulerAngles = euler
    }
    
}
