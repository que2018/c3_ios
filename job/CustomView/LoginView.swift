
import UIKit
import Toaster
import Alamofire

class LoginView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var nameTextField: BottomBorderTextField!
    @IBOutlet weak var passwordTextField: BottomBorderTextField!
    @IBOutlet weak var loginButton: LoadingButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configView()
    }
    
    private func configView() {
        Bundle.main.loadNibNamed("LoginView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        let borderColor = UIColor(red: 207 / 255, green: 207 / 255, blue: 207 / 255, alpha: 1.0)

        nameTextField.setBottomBorder(borderColor: borderColor, width: 1.2)
        passwordTextField.setBottomBorder(borderColor: borderColor, width: 1.2)
    }
    
    @IBAction func submitLogin(_ sender: Any) {
        self.endEditing(true)
        
        let name = self.nameTextField.text!
        let password = self.passwordTextField.text!
        
        self.loginButton.showLoading()
            
        self.nameTextField.isUserInteractionEnabled = false
        self.passwordTextField.isUserInteractionEnabled = false
            
        let parameters:[String: String] = [
            "name": name,
            "password": password
        ]
                
        Alamofire.request(ADDR.LOGIN, method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseJSON { response in
            self.loginButton.hideLoading()

            self.nameTextField.isUserInteractionEnabled = true
            self.passwordTextField.isUserInteractionEnabled = true
            
            if let json = response.result.value {
                let jsonData = json as! [String : Any]
                
                let code = jsonData["code"] as! Int
                
                if code == 0 {
                    NotificationCenter.default.post(name: .login, object: nil)
                } else {
                    let message = jsonData["message"] as! String
                    
                    let toast = Toast(text: message, duration: Delay.short)
                    ToastView.appearance().font = UIFont.systemFont(ofSize: 18)
                    toast.show()
                }
            }
        }
    }
}

