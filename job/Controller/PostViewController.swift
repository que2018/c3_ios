
import UIKit
import Alamofire

class PostViewController: UIViewController {

    var postId = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    
    private let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    private func loadData() {
        self.loadingIndicator.center = self.view.center
        self.loadingIndicator.hidesWhenStopped = true
        self.loadingIndicator.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(self.loadingIndicator)
        self.loadingIndicator.startAnimating()
        
        let url = ADDR.POST + "?id=" + self.postId
        
        Alamofire.request(url) .responseJSON { response in
            self.loadingIndicator.stopAnimating()
            
            if let json = response.result.value {
                let jsonData = json as! [String : Any]
                let message = jsonData["message"] as! String
                
                if message == "success" {
                    let post = jsonData["data"] as! [String : Any]
                    let title = post["title"] as! String
                    let description = post["description"] as! String
                    
                    DispatchQueue.main.async {
                        self.loadingIndicator.stopAnimating()
                        
                        self.titleLabel.text = title
                        self.descriptionText.text = description
                    }
                }
            }
        }
    }
    
    @IBAction private func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
