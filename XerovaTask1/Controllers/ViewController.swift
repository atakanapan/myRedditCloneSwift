//
//  ViewController.swift
//  XerovaTask1
//
//  Created by Atakan Apan on 6/7/22.
// ✅ ❌ ❔

import UIKit
import CoreData

// İnternet kkontrolü yap ✅
// Eğer internet gibi servis çaprısını engelleyecek birşey varsa ✅
// coredata üzerinde postData modeli oluştur servis çağrısı sonrası gelen datalaro buraya kaydet. ✅
// Detay ekranında datayı coredatadan al.
// Not: Uygulama açıldığında coredata kontrolü yap data var mı yok mu?

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate{
    var networkManager = NetworkManager()
    var posts:[Child]?
    var indexPathPressed: Int = 0
    
    //Liste kismi
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.register(TableHeader.self, forHeaderFooterViewReuseIdentifier: "header")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if NetworkMonitor.shared.isConnected {
            print("Connected")
            networkManager.fetchData(){(children) in
                if let children = children {
                    self.posts = children
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    self.saveUserData(children)
                }
            }
            //getUserData()
        }
        else {
            print("Not Connected")
            
            self.tableView.reloadData()
        }
        
        view.addSubview(tableView)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    //generic perform segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let postData = posts?[indexPathPressed] else {
            // Kullanıcıya neden diğer ekrana gidemediğini pop up ile açıkla ✅
            let errorPopUp = UIAlertController(title: "Bir aksilik oldu", message: "Maalesef icerige ulasilamiyor.", preferredStyle: .alert)
            let tamamButton = UIAlertAction(title: "Tamam", style: .default, handler: { (action) -> Void in /* (action) */})
            errorPopUp.addAction(tamamButton)
            self.present(errorPopUp, animated: true, completion: nil)
            
            return
        }
        // Create a new variable to store the instance of the SecondViewController
        // set the variable from the SecondViewController that will receive the data
        if segue.identifier == "showSVC"{
            let destinationVC = segue.destination as! SecondViewController
            destinationVC.postData = postData
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        //uitableviewcell class olustur (custom cell)
        
        if let imageView = cell.imageView, imageView.transform == .identity {
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
            
            if let thumbControl = posts?[indexPath.row].data.thumbnail {
                switch thumbControl {
                case "default", "self", "nsfw", "":
                    imageView.image = nil
                default:
                    imageView.loadFrom(URLAddress: (posts?[indexPath.row].data.thumbnail ?? "https://www.baloglu.com/themes/canvas-1/img/no-image.png"))
                }
            }
            else {
                imageView.image = nil
            }
            
        }
        cell.textLabel?.text = "🔝\((posts?[indexPath.row].data.score ) ?? 0 % 1000)k" + "  |  " + (posts?[indexPath.row].data.title ?? "Default Title")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Cell Tapped")
        indexPathPressed = indexPath.row
        
        performSegue(withIdentifier: "showSVC", sender: Any?.self)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 105
    }
    
    func deleteEntries() {
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Posts")
            let request: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try context.execute(request)
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func saveUserData(_ posts: [Child]) {
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            self.deleteEntries()
            for child in posts {
                let post = child.data
                let newDatas = NSEntityDescription.insertNewObject(forEntityName: "Posts", into: context)
                newDatas.setValue(post.id, forKey: "id")
                newDatas.setValue(post.score, forKey: "score")
                newDatas.setValue(post.selftext, forKey: "selftext")
                newDatas.setValue(post.thumbnail, forKey: "thumbnail")
                newDatas.setValue(post.title, forKey: "title")
                newDatas.setValue(post.url, forKey: "url")
            }
            do {
                try context.save()
                print("Success")
            } catch {
                print("Error saving: \(error)")
            }
        }
    }
    func getUserData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Posts")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                print(results.count)
                for result in results as! [NSManagedObject] {
                    print(result.value(forKey: "title") ?? "Error Not Found")
                }
            }
        } catch {
            print(error)
        }
    }
    func setCDtoPosts(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Posts>(entityName: "Posts")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    self.posts = result as? [Child]
                }
            }
        } catch {
            print(error)
        }
    }
    
}
//coredata mvvm

