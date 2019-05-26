
import UIKit
import Alamofire
import CRRefresh

class CategoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var selectedCategoryId = ""
    private var categories = [Category]()
    private var categoryCollectionview: UICollectionView!
    private let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    private let columnLayout = ColumnFlowLayout(
        cellsPerRow: 4,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configView()
        
        loadData()
    }
    
    private func configView() {
        let layout: UICollectionViewFlowLayout = columnLayout
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: view.frame.width, height: 100)
        
        categoryCollectionview = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        categoryCollectionview.dataSource = self
        categoryCollectionview.delegate = self
        categoryCollectionview.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "category_cell")
        
        categoryCollectionview.contentInsetAdjustmentBehavior = .always
        categoryCollectionview.showsVerticalScrollIndicator = false
        categoryCollectionview.backgroundColor = UIColor.white
        categoryCollectionview.alwaysBounceVertical = true
        
        self.view.addSubview(categoryCollectionview)
        
        categoryCollectionview.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            self!.loadData()
        }
    }
    
    private func loadData() {
        categories.removeAll()
        
        self.loadingIndicator.center = self.view.center
        self.loadingIndicator.hidesWhenStopped = true
        self.loadingIndicator.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(self.loadingIndicator)
        self.loadingIndicator.startAnimating()
        
        Alamofire.request(ADDR.CATEGORIES) .responseJSON { response in
            self.loadingIndicator.stopAnimating()
            
            if let json = response.result.value {
                let jsonData = json as! [String : Any]
                let message = jsonData["message"] as! String
                
                if message == "success" {
                    let data = jsonData["data"] as! [String : Any]
                    let listJson = data["list"] as! NSArray
                    
                    for categoryJson in listJson {
                        let categoryData = categoryJson as! [String : Any]
                        
                        let id = categoryData["_id"] as! String
                        let name = categoryData["Name"] as! String
                        let imageUrl = categoryData["ImageUrl"] as! String
                        
                        let category = Category()
                        category.id = id
                        category.name = name
                        category.imageUrl = imageUrl
                        self.categories.append(category)
                    }
                    
                    DispatchQueue.main.async {
                        self.loadingIndicator.stopAnimating()
                        self.categoryCollectionview.reloadData()
                        self.categoryCollectionview.cr.endHeaderRefresh()
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let categoryCell = categoryCollectionview.dequeueReusableCell(withReuseIdentifier: "category_cell", for: indexPath) as! CategoryCollectionViewCell
        
        let name = categories[indexPath.row].name
        let imageUrl = categories[indexPath.row].imageUrl
        
        categoryCell.nameLabel.text = name
        
        let url = URL(string: imageUrl)
        let data = try? Data(contentsOf: url!)
        categoryCell.imageView.image = UIImage(data: data!)
        
        return categoryCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCategoryId = categories[indexPath.row].id
        performSegue(withIdentifier: "segue_c_pc", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_c_pc" {
            if let postCategoryController = segue.destination as? PostCategoryViewController {
                postCategoryController.categoryId = self.selectedCategoryId
            }
        }
    }
}
