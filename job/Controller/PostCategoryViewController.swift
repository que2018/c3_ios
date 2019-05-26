import UIKit
import Alamofire
import CRRefresh

class PostCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var postId = ""
    var pointer = 0
    var categoryId = ""
    var locker = false
    var posts = [Post]()
    var postTableView: UITableView!
    let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var postTableViewWrap: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        postTableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight))
        postTableView.backgroundColor = .clear
        postTableView.showsVerticalScrollIndicator = false
        postTableView.separatorStyle  = UITableViewCell.SeparatorStyle.none
        postTableView.register(UINib(nibName: "PostCell", bundle: Bundle.main), forCellReuseIdentifier: "PostCell")
        
        postTableView.dataSource = self
        postTableView.delegate = self
        self.postTableViewWrap.addSubview(postTableView)
        
        postTableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            self!.refreshData()
        }
        
        refreshData()
    }
    
    func refreshData() {
        pointer = 0
        locker = false
        posts.removeAll()
        
        self.loadingIndicator.center = self.view.center
        self.loadingIndicator.hidesWhenStopped = true
        self.loadingIndicator.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(self.loadingIndicator)
        self.loadingIndicator.startAnimating()
        
        let parameters : Parameters = [
            "_category_id" : self.categoryId,
            "start" : 0,
            "limit" : CONST.PAGE_LIMIT
        ]
                
        Alamofire.request(ADDR.POSTS, method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseJSON { response in
            self.loadingIndicator.stopAnimating()
            
            if let json = response.result.value {
                let jsonData = json as! [String : Any]
                let message = jsonData["message"] as! String
                
                if message == "success" {
                    let temp = jsonData["data"] as! [String : Any]
                    let listJson = temp["list"] as! NSArray
                    
                    if listJson.count > 0 {
                        for postJson in listJson {
                            let postData = postJson as! [String : Any]
                            let id = postData["_id"] as! String
                            let title = postData["title"] as! String
                            let author = postData["author"] as! String
                            let description = postData["description"] as! String
                            let dateAdded = postData["dateAdded"] as! String
                            let viewCount = postData["viewCount"] as! Int
                            
                            let post = Post()
                            post.id = id
                            post.title = title
                            post.author = author
                            post.description = description
                            post.dateAdded = dateAdded
                            post.viewCount = viewCount
                            self.posts.append(post)
                        }
                        
                        self.pointer = self.posts.count - 1
                        
                        DispatchQueue.main.async {
                            self.loadingIndicator.stopAnimating()
                            self.postTableView.reloadData()
                        }
                    }
                    
                    self.postTableView.cr.endHeaderRefresh()
                }
            }
        }
    }
    func loadData() {
        if(self.pointer < 0 || self.locker) {
            return
        }
        
        self.locker = true
        
        let parameters : Parameters = [
            "_category_id" : self.categoryId,
            "start" : self.pointer + 1,
            "limit" : CONST.PAGE_LIMIT
        ]
        
        Alamofire.request(ADDR.POSTS, method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseJSON { response in
            if let json = response.result.value {
                let jsonData = json as! [String : Any]
                let message = jsonData["message"] as! String
                
                if message == "success" {
                    var newPosts = [Post]()
                    
                    let data = jsonData["data"] as! [String : Any]
                    let listJson = data["list"] as! NSArray
                    
                    if listJson.count > 0 {
                        for postJson in listJson {
                            let postData = postJson as! [String : Any]
                            let id = postData["_id"] as! String
                            let title = postData["title"] as! String
                            let author = postData["author"] as! String
                            let description = postData["description"] as! String
                            let dateAdded = postData["dateAdded"] as! String
                            let viewCount = postData["viewCount"] as! Int
                            
                            let post = Post()
                            post.id = id
                            post.title = title
                            post.author = author
                            post.description = description
                            post.dateAdded = dateAdded
                            post.viewCount = viewCount
                            self.posts.append(post)
                            newPosts.append(post)
                        }
                        
                        DispatchQueue.main.async() {
                            if newPosts.count > 0 {
                                self.postTableView.beginUpdates()
                            
                                for (index, post) in newPosts.enumerated() {
                                    let row = self.pointer + 1 + index
                                    self.postTableView.insertRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
                                }
                            
                                self.postTableView.endUpdates()
                        
                                self.pointer = self.pointer + listJson.count
                            }
                            
                            self.locker = false
                        }
                    } else {
                        self.pointer = -1
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        postId = self.posts[indexPath.row].id
        performSegue(withIdentifier: "segue_post2", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let postTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        postTableViewCell.backgroundColor = .clear
        postTableViewCell.selectionStyle = .none
        
        var title = posts[indexPath.row].title
        
        if title.count > 15 {
            title = title.prefix(15) + "..."
        }
        
        postTableViewCell.titleLabel.text = String(title)
        
        var description = posts[indexPath.row].description
        description = String(description)
        description = description.replacingOccurrences(of: "\n", with: " ")
        
        if description.count > 70 {
            description = description.prefix(70) + " ..."
        }
        
        postTableViewCell.descriptionLabel.text = description
        
        return postTableViewCell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            loadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_post2" {
            if let postViewController = segue.destination as? PostViewController {
                postViewController.postId = postId
            }
        }
    }
    
    @IBAction func back(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
}
