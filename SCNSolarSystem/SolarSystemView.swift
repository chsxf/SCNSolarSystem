//
//  SolarSystemView.swift
//  SCNSolarSystem
//
//  Created by Christophe SAUVEUR on 13/12/2021.
//

import SceneKit
import GameplayKit

class SolarSystemView: SCNView, SCNSceneRendererDelegate {
    
    private var lastTime: TimeInterval?
    
    private var entities = [GKEntity]()
    
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
        
        let sun = createSphere(withRadius: description.sun.engineRadius, lightingModel: .constant, texture: description.sun.texture)
        sun.name = "Sun"
        scene.rootNode.addChildNode(sun)
        
        let sunEntity = GKEntity()
        let sunComponent = RotationComponent(node: sun, rotationPeriod: description.sun.engineRotationPeriod)
        sunEntity.addComponent(sunComponent)
        entities.append(sunEntity)
        
        let light = SCNLight()
        light.type = .omni
        let lightNode = SCNNode()
        lightNode.name = "Sun Light"
        lightNode.light = light
        scene.rootNode.addChildNode(lightNode)
        
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.intensity = 20
        let ambientLightNode = SCNNode()
        ambientLightNode.name = "Ambient Space Light"
        ambientLightNode.light = ambientLight
        scene.rootNode.addChildNode(ambientLightNode)
        
        for stellarObject in description.stellarObjects {
            let node = createSphere(withRadius: stellarObject.engineRadius, lightingModel: .blinn, texture: stellarObject.texture, additionalTextures: stellarObject.additionalTextures)
            node.position = SCNVector3(stellarObject.enginePerihelion, 0, 0)
            node.name = stellarObject.name
            scene.rootNode.addChildNode(node)
            
            let planetEntity = GKEntity()
            let planetComponent = RotationComponent(node: node, rotationPeriod: stellarObject.engineRotationPeriod)
            planetEntity.addComponent(planetComponent)
            entities.append(planetEntity)
            
            if stellarObject.rings != nil {
                let ringsNode = createRings(withInnerRadius: stellarObject.rings!.engineInnerRadius, outerRadius: stellarObject.rings!.engineOuterRadius, texture: stellarObject.rings!.texture)
                node.addChildNode(ringsNode)
            }
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
    
    func createRings(withInnerRadius innerRadius: Float, outerRadius: Float, texture: String) -> SCNNode {
        var vertices = [SCNVector3]()
        var normals = [SCNVector3]()
        var uvs = [CGPoint]()
        var indices = [Int32]()
        
        let segmentCount = 96
        
        let deg2Rad = Float.pi / 180
        let angleIncrement: Float = 360.0 / Float(segmentCount)
        let uvIncrement = 1.0 / Double(segmentCount)
        var index: Int32 = 0
        for i in 0...segmentCount {
            let angle = -angleIncrement * Float(i)
            let radAngle = angle * deg2Rad
            
            let cosinus = cos(radAngle)
            let sinus = sin(radAngle)
            
            let uvY = uvIncrement * Double(i)
            
            vertices.append(SCNVector3(cosinus * innerRadius, 0, sinus * innerRadius))
            normals.append(SCNVector3(0, -1, 0))
            uvs.append(CGPoint(x: 0.0, y: uvY))
            
            vertices.append(SCNVector3(cosinus * outerRadius, 0, sinus * outerRadius))
            normals.append(SCNVector3(0, -1, 0))
            uvs.append(CGPoint(x: 1.0, y: uvY))
            
            indices.append(index)
            indices.append(index + 1)
            index += 2
        }
        
        let verticesSource = SCNGeometrySource(vertices: vertices)
        let normalsSource = SCNGeometrySource(normals: normals)
        let uvsSource = SCNGeometrySource(textureCoordinates: uvs)
        let element = SCNGeometryElement(indices: indices, primitiveType: .triangleStrip)
        
        let topMaterial = SCNMaterial()
        topMaterial.lightingModel = .blinn
        topMaterial.diffuse.contents = texture
        
        let bottomMaterial = SCNMaterial()
        bottomMaterial.lightingModel = .blinn
        bottomMaterial.diffuse.contents = texture
        bottomMaterial.cullMode = .front
        
        let geometry = SCNGeometry(sources: [verticesSource, normalsSource, uvsSource], elements: [element, element])
        geometry.materials = [topMaterial, bottomMaterial]
        
        let node = SCNNode(geometry: geometry)
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let lastTime = lastTime else {
            lastTime = time
            return
        }

        let diff = time - lastTime
        self.lastTime = time

        for entity in entities {
            entity.update(deltaTime: diff)
        }
    }
    
}
