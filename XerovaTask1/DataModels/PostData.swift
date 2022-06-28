//
//  PostData.swift
//  XerovaTask1
//
//  Created by Atakan Apan on 6/7/22.
//

//codable decoable identifier arastir
import Foundation

// MARK: - Welcome
public struct Results: Decodable {
    let data: ResultsData
}

// MARK: - WelcomeData
public struct ResultsData: Decodable {
    let children: [Child]
}

// MARK: - Child
public struct Child: Decodable {
    var data: Post
}

// MARK: - ChildData
struct Post: Decodable, Identifiable{
    var selftext: String?
    var id: String?
    var title: String?
    var score: Int?
    var url: String? //image
    var thumbnail: String?
    //let preview: Preview?
}

/*// MARK: - ResizedIcon
struct ResizedIcon: Codable {
    let url: String
    let width, height: Int
}

// MARK: - Preview
struct Preview: Codable {
    let images: [Image]
}

// MARK: - Image
struct Image: Codable {
    let source: ResizedIcon

}*/
