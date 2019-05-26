
import UIKit

class TabBarViewController: UITabBarController {

    let tabBarHeight : CGFloat = 55.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set bar text size
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Didot", size: 12)!],for: .normal)
    }
    
    override func viewWillLayoutSubviews() {
        //change tab height
        var tabFrame = self.tabBar.frame;
        tabFrame.size.height = tabBarHeight;
        tabFrame.origin.y = self.view.frame.size.height - tabBarHeight;
        self.tabBar.frame = tabFrame;
    }
}
