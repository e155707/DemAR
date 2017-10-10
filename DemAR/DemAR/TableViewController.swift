import UIKit
import SceneKit
import ARKit

class TableViewController: UIViewController{
    
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
        appDelegate.viewController.Object()
        
    }
    
    @IBAction func AddFood(_ sender: Any) {
        appDelegate.Food = 1
    }
    
    @IBAction func Back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //@IBOutlet weak var 戻る: UIButton!
    
}

