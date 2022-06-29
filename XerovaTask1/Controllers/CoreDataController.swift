//
//  CoreDataController.swift
//  XerovaTask1
//
//  Created by Atakan Apan on 6/29/22.
//

import Foundation
import UIKit
import CoreData

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
        deleteEntries()
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
func setCDtoPosts() -> [Posts]?{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<Posts>(entityName: "Posts")
    fetchRequest.returnsObjectsAsFaults = false
    var results: [Posts] = [Posts]()
    do {
        results = try context.fetch(fetchRequest)
    } catch {
        print("Error while setCDtoPosts: \(error)")
    }
    if results.count > 0{
        return results
    }
    else{
        return nil
    }
}
