import UIKit
import SceneKit
import ARKit

class TableViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //背景色を透明にする
        self.view.backgroundColor = UIColor.clear
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let testCell:UICollectionViewCell =
            collectionView.dequeueReusableCell(withReuseIdentifier: "Cell1",
                                               for: indexPath)
        testCell.backgroundColor = UIColor(red: CGFloat(drand48()),
                                       green: CGFloat(drand48()),
                                       blue: CGFloat(drand48()),
                                       alpha: 1.0)
        return testCell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // section数は１つ
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        // 要素数を入れる、要素以上の数字を入れると表示でエラーとなる
        return 3;
    }
}

