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
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var planes:[Plane] = []

    let decosName = "decos"
    let foodsName = "foods"
    
    // リストから選ばれたモデルを一時保存する関数
    var selectDecoNode:SCNNode? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate.viewController = self
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
        
        appDelegate.Object = 0
        
        // タップされた場合, どの関数を呼ぶのかをactionで指定
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(tapGesture(gestureRecognizer:)))

        
        
        // sceneView(ARSCNView)に適用
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        
        // test スワイプしたら全オブジェクト削除

        let directionList:[UISwipeGestureRecognizerDirection] = [.up, .down, .right, .left]
        
        for direction in directionList {
            //4方向のスワイプリコグナイザーをラベルに登録する。
            let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(gestureRecognizer:)))
            swipeRecognizer.direction = direction
            
            sceneView.addGestureRecognizer(swipeRecognizer)
        }
        node_init()

    }
    
    
    // それぞれのnodeで管理するので, その初期設定を行う関数.
    func node_init(){
        // 飾りの管理用node
        let decos:SCNNode = SCNNode()
        // 食べ物の管理用node
        let foods:SCNNode = SCNNode()
        decos.name = "decos"
        foods.name = "foods"
        sceneView.scene.rootNode.addChildNode(decos)
        sceneView.scene.rootNode.addChildNode(foods)
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
    
    /** Object
     *  アイコンリスト(食べ物や, 飾りを選べるテーブル)のボタン遷移先.
     */
    func Object(){
        // 蝶々モデルの読み込み
        let deco_Scene = SCNScene(named: "art.scnassets/model/decoration/butterfly/butterfly.scn")!
        let deco_Node = deco_Scene.rootNode.childNode(withName: "butterfly", recursively: true)
        
        // 蝶々の大きさや, 出現先の変更
        deco_Node?.scale = SCNVector3(0.0001, 0.0001, 0.0001)
        deco_Node?.position = SCNVector3(0, 0, -0.1)
    
        // 蝶々を出現
        //sceneView.scene.addChildNode(deco_Node!)
        // 蝶々を出現させ中央に固定する. (カメラに付随させる.)
        sceneView.pointOfView?.addChildNode(deco_Node!)
        
        // 蝶々のモデルを引き渡し.
        selectDecoNode = deco_Node
    }

    /** renderer(didAdd)
     *  平面検知が成功した場合に呼び出されるメソッド.
     */
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
        // 管理用配列に追加
        node.childNode(withName: foodsName, recursively: false)?.addChildNode(food_Node!)
    
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
    
    // タップした際に呼び出される関数.
    @objc func tapGesture(gestureRecognizer: UITapGestureRecognizer){
        // もし, selectDecoNodeに何も入っていなければ, 何もしない.
        if let copyNode = selectDecoNode?.clone() {
            // selectDecoNodeに物体が入っている場合, 表示されている位置に追加.
            copyNode.position = (selectDecoNode?.worldPosition)!
            
            // 管理用配列に追加
            sceneView.scene.rootNode.childNode(withName: decosName, recursively: false)?.addChildNode(copyNode)
        }
        else{
            return
        }
    }
    
    // スワイプした時に呼び出されるメソッド
    @objc func didSwipe(gestureRecognizer: UISwipeGestureRecognizer){
        // 管理用node含め, その子ノードを全部削除.
        reset()

    }
    
    // 管理用node含め, その子ノードを全部削除する関数
    func reset(){
        sceneView.scene.rootNode.childNode(withName: decosName, recursively: false)?.runAction(SCNAction.removeFromParentNode())
        sceneView.scene.rootNode.childNode(withName: foodsName, recursively: false)?.runAction(SCNAction.removeFromParentNode())
        // また, 管理用の新しいノードを作る.
        node_init()
    }
}
