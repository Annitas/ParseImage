//
//  ResultViewController.swift
//  ParseImage
//
//  Created by Anita Stashevskaya on 12.02.2024.
//

import UIKit

class ResultViewController: UIViewController {
    var images: [String: String] = [:]
    var imageUrl: String?
    var imageSize: String?

//    init() { //images: [String: String]
//        super.init(nibName: nil, bundle: nil)
////        self.images = images
//        
//    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        // Do any additional setup after loading the view.
    }
}
