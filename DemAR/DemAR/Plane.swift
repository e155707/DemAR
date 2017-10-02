//
//  Plane.swift
//  DemAR
//
//  Created by Arakaki Yuichirou on 2017/09/30.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class Plane: SCNNode {
    
    var anchor: ARPlaneAnchor!
    
    private var planeGeometry: SCNBox!
    
    init(anchor initAnchor: ARPlaneAnchor) {
        super.init()
        
        // この平面のAnchorを保持
        anchor = initAnchor
        
        // Anchorを元にノードを生成
        planeGeometry = SCNBox(width: CGFloat(initAnchor.extent.x),
                               height: 0.01,
                               length: CGFloat(initAnchor.extent.z),
                               chamferRadius: 0)
        let planeNode = SCNNode(geometry: planeGeometry)
        
        // 平面の位置を指定
        planeNode.position = SCNVector3Make(initAnchor.center.x, 0, initAnchor.center.z)
        // 平面の判定を追加
        planeNode.physicsBody = SCNPhysicsBody(type: .kinematic,
                                               shape: SCNPhysicsShape(geometry: planeGeometry,
                                                                      options: nil))
        
        // 写した時に位置がわかるようにうっすら黒い色を指定
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)
        planeNode.geometry?.firstMaterial = material
        
        // 箱を生成
        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let cubeNode = SCNNode(geometry: cube)
        
        // 箱の判定を追加
        let cubeShape = SCNPhysicsShape(geometry: cube, options: nil)
        cubeNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: cubeShape)
        
        // sceneView上のタップ座標のどこに箱を出現させるかを指定
        cubeNode.position = SCNVector3Make(initAnchor.center.x, 0.05, initAnchor.center.z)
        
        addChildNode(cubeNode)
        addChildNode(planeNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 平面情報がアップデートされた時に呼ぶ
    func update(anchor: ARPlaneAnchor) {
        // 改めて諸々設定
        
        planeGeometry.width = CGFloat(anchor.extent.x)
        planeGeometry.length = CGFloat(anchor.extent.z)
        position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        
        if let node = childNodes.first {
            node.physicsBody = SCNPhysicsBody(type: .kinematic,
                                              shape: SCNPhysicsShape(geometry: planeGeometry,
                                                                     options: nil))
        }
    }
    
}
