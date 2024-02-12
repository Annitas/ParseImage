//
//  ResultViewController.swift
//  ParseImage
//
//  Created by Anita Stashevskaya on 12.02.2024.
//

import UIKit

final class ResultViewController: UIViewController {
    var images = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // Создаем вертикальный стек вид для размещения изображений и ссылок
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Добавляем изображения и ссылки на них в стек вид
        for imageUrl in images {
            var str = imageUrl
            str.insert("s", at: imageUrl.index(imageUrl.startIndex, offsetBy: 4))
            print(str)
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
                            
                            stackView.addArrangedSubview(imageView)
                            stackView.addArrangedSubview(label)
                        }
                    } else {
                        print("Не удалось загрузить изображение по URL: \(str)")
                    }
                }.resume()
            } else {
                print("Некорректный URL: \(imageUrl)")
            }
        }
    }
}
