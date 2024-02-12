//
//  ResultViewController.swift
//  ParseImage
//
//  Created by Anita Stashevskaya on 12.02.2024.
//

import UIKit
import SnapKit

final class ResultViewController: UIViewController {
    var images = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        for imageUrl in images {
            var str = imageUrl
            str.insert("s", at: imageUrl.index(imageUrl.startIndex, offsetBy: 4))
            if let url = URL(string: str) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            let imageView = UIImageView(image: image)
                            imageView.contentMode = .scaleAspectFit
                            imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
                            imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
                            
                            let label = UILabel()
                            label.text = str
                            label.textAlignment = .center
                            
                            let sizeLabel = UILabel()
                            sizeLabel.text = "\(data.count)"
                            sizeLabel.textAlignment = .center
                            
                            stackView.addArrangedSubview(imageView)
                            stackView.addArrangedSubview(label)
                            stackView.addArrangedSubview(sizeLabel)
                        }
                    } else {
                        print("Не удалось загрузить изображение по URL: \(str)")
                    }
                }.resume()
            } else {
                print("Некорректный URL: \(str)")
            }
        }
    }
}
