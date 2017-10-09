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
    //@IBOutlet var sceneView: ARSKView!
    
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
        
 
        // 蝶々をNodeに落とし込む.
        let deco_Scene = SCNScene(named: "art.scnassets/model/decoration/butterfly/butterfly.scn")!
        let deco_Node = deco_Scene.rootNode.childNode(withName: "butterfly", recursively: true)
        
        // 手動で蝶々のサイズを変更
        deco_Node?.scale = SCNVector3(0.001, 0.001, 0.001)
        // 位置 カメラを原点として左右0 下に1m 奥に2mに設定
        deco_Node?.position = SCNVector3(0, -1, -2)
        // 蝶々を出現させる.
        sceneView.scene.rootNode.addChildNode(deco_Node!)

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
        
        // cakeをNodeに落とし込む.
        let food_Scene = SCNScene(named: "art.scnassets/model/food/cake/chococake.scn")!
        let food_Node = food_Scene.rootNode.childNode(withName: "chococake", recursively: true)
        
        // 平面検知した場所にケーキを置く
        food_Node?.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
        // ケーキを出現させる.
        node.addChildNode(food_Node!)
    
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
