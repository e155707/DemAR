//
//  ViewController.swift
//  DemAR
//
//  Created by 赤堀　貴一 on 2017/09/26.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var planes:[Plane] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // デバッグ時用オプション
        // ARKitが感知しているところに「+」がいっぱい出てくるようになる
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        
        
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // ARKit用。平面を検知するように指定
        configuration.planeDetection = .horizontal
        // 現実の環境光に合わせてレンダリングしてくれるらしい
        //configuration.isLightEstimationEnabled = true
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // 平面を生成
        let plane = Plane(anchor: planeAnchor)
        
        /*
         // 箱を生成
         let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
         let cubeNode = SCNNode(geometry: cube)
         
         // 箱の判定を追加
         let cubeShape = SCNPhysicsShape(geometry: cube, options: nil)
         cubeNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: cubeShape)
         
         // sceneView上のタップ座標のどこに箱を出現させるかを指定
         cubeNode.position = SCNVector3Make(planeAnchor.center.x, 0.05, planeAnchor.center.z)
         
         node.addChildNode(cubeNode)
         */
        
        // 蝶々を出現
        let deco_scene = SCNScene(named: "model/decoration/butterfly/model.obj")!
        let deco_Node = deco_scene.rootNode.childNode(withName: "butterfly", recursively: true)
        
        deco_Node?.position = SCNVector3(planeAnchor.center.x, 0.1, planeAnchor.center.z)
        
        node.addChildNode(deco_Node!)
        
        
        // ノードを追加
        node.addChildNode(plane)
        
        // 管理用配列に追加
        planes.append(plane)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // updateされた平面ノードと同じidのものの情報をアップデート
        for plane in planes {
            if plane.anchor.identifier == anchor.identifier,
                let planeAnchor = anchor as? ARPlaneAnchor {
                plane.update(anchor: planeAnchor)
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        // updateされた平面ノードと同じidのものの情報を削除
        for (index, plane) in planes.enumerated().reversed() {
            if plane.anchor.identifier == anchor.identifier {
                planes.remove(at: index)
            }
        }
    }
}
