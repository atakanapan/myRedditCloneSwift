//
//  NetworkManager.swift
//  XerovaTask1
//
//  Created by Atakan Apan on 6/7/22.
//

import Foundation
import UIKit

public class NetworkManager: ObservableObject{

    func fetchData(completion: @escaping([Child]?) -> ()){
        var posts = [Child]()
        if let url = URL(string: "https://www.reddit.com/.json"){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error == nil{
                    let decoder = JSONDecoder()
                    if let safeData = data{
                        do{
                            let results = try decoder.decode(Results.self, from: safeData)
                                posts = results.data.children
                                completion(posts)
                        }
                        catch{
                            print(error)
                        }
                    

                    }
                }
                else{
                    completion(nil)
                }
               
            }
            task.resume()
        }
    }
    
}

extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                        self?.image = loadedImage
                }
            }
        }
    }
}
//myImageView.loadFrom(URLAddress: "example.com/image.png")
