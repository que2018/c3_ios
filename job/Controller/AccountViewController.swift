
import UIKit

class AccountViewController: UIViewController {

    var loginView = LoginView()
    var accountView = AccountView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //addLoginView()
        addLoginView()
    }
    
    private func addLoginView() {
        let screenSzie = UIScreen.main.bounds
        let screenWidth = screenSzie.width
        let screenHeight = screenSzie.height
        let width = screenWidth
        let height = screenHeight
        
        loginView.frame = CGRect(x:0, y: 0, width: width, height: height)
        loginView.translatesAutoresizingMaskIntoConstraints = false
        loginView.alpha = 1
        
        self.view.addSubview(loginView)
        
        let widthConstraint = NSLayoutConstraint(item: loginView, attribute: .width, relatedBy: .equal,toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: width)
        let heightConstraint = NSLayoutConstraint(item: loginView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height)
        let xConstraint = NSLayoutConstraint(item: loginView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: loginView  , attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        
        self.view.addConstraints([xConstraint, yConstraint, widthConstraint, heightConstraint])
        
        NotificationCenter.default.addObserver(self, selector: #selector(setToPeru(notification:)), name: .login, object: nil)
    }
    
    private func addAccountView() {
        loginView.removeFromSuperview()
        
        let screenSzie = UIScreen.main.bounds
        let screenWidth = screenSzie.width
        let screenHeight = screenSzie.height
        let width = screenWidth
        let height = screenHeight
        
        accountView.frame = CGRect(x:0, y: 0, width: width, height: height)
        accountView.translatesAutoresizingMaskIntoConstraints = false
        accountView.alpha = 1
        
        self.view.addSubview(accountView)
        
        let widthConstraint = NSLayoutConstraint(item: accountView, attribute: .width, relatedBy: .equal,toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: width)
        let heightConstraint = NSLayoutConstraint(item: accountView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height)
        let xConstraint = NSLayoutConstraint(item: accountView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: accountView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        
        self.view.addConstraints([xConstraint, yConstraint, widthConstraint, heightConstraint])
    }
    
    @objc func setToPeru(notification: NSNotification) {
       addAccountView()
    }
}

