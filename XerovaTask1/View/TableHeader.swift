//
//  TableHeader.swift
//  XerovaTask1
//
//  Created by Atakan Apan on 6/8/22.
//

import Foundation
import UIKit

class TableHeader: UITableViewHeaderFooterView {
    static let identifier = "TableHeader"
    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Reddit"
        label.font = .systemFont(ofSize: 28, weight: .semibold)
        label.textAlignment = .left
        return label
    }()
    private let label2: UILabel = {
        let label = UILabel()
        label.text = "by AtakanA."
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textAlignment = .left
        return label
    }()
    
    override init(reuseIdentifier: String?){
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        contentView.addSubview(label2)
        contentView.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        imageView.frame = CGRect(x: 20,
                                 y: 49,
                                 width: 32,
                                 height: 32)
        label.sizeToFit()
        label.frame = CGRect(x: imageView.frame.size.height+30,
                             y: 46,
                             width: contentView.frame.size.width-32,
                             height: 32)
        label2.sizeToFit()
        label2.frame = CGRect(x: imageView.frame.size.height+48,
                             y: 66,
                             width: contentView.frame.size.width-32,
                             height: 32)
    }
}
