import UIKit
import SceneKit
import ARKit

class TableViewController: UIViewController{
    
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    //var sceneView:ViewController =  UIViewController.delegate as! ViewController
    //var VS = ViewController()
    
    //@IBOutlet var AddObject: UIButton!
    @IBOutlet weak var AddObject: UIButton!
    //var VC = ViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //背景色を透明にする
        self.view.backgroundColor = UIColor.clear
        
        let image0:UIImage = UIImage(named:"texture")!
        AddObject.setImage(image0, for: UIControlState())
    }
    
    //let image = UIImage(named: "texture")
    //button.setImage(image, for: UIControlState())
    
    
    @IBAction func AddObject(_ sender: Any) {
        //appDelegate.Object = 1
        appDelegate.viewController.Object()
        //ViewController.Object(ViewController)
        //let scene = SCNScene()
        //VC.sceneView.scene = scene
        
        //let deco_Scene = SCNScene(named: "art.scnassets/model/decoration/butterfly/butterfly.scn")
        ///let deco_Node = deco_Scene?.rootNode.childNode(withName: "butterfly", recursively: true)
        
        // 手動で蝶々のサイズを変更
        //deco_Node?.scale = SCNVector3(0.001, 0.001, 0.001)
        // 位置 カメラを原点として左右0 下に1m 奥に2mに設定
        //deco_Node?.position = SCNVector3(0, -1, -2)
        // 蝶々を出現させる.
        //VC.sceneView.scene.rootNode.addChildNode(deco_Node!)
    }
    
    
    //@IBOutlet weak var 戻る: UIButton!
    
}

