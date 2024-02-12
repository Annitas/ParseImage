//
//  ViewController.swift
//  ParseImage
//
//  Created by Anita Stashevskaya on 12.02.2024.
//

import UIKit
import SnapKit
import SwiftSoup

final class ViewController: UIViewController {
    let resultVC = ResultViewController()
    
    private let enterLinkField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.layer.cornerRadius = 20
        textField.text = "https://forum.awd.ru/viewtopic.php?f=1011&t=165935"
        textField.layer.borderColor = UIColor.brown.cgColor
        textField.layer.borderWidth = 1.7
        textField.backgroundColor = .clear
        textField.textColor = UIColor(named: "mainTextColor")
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
            
        return textField
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("SEARCH", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.frame = CGRect(x: 15, y: -50, width: 300, height: 500)
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var imageDict = [String]() //imageURL - size
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(enterLinkField)
        view.addSubview(searchButton)
        addConstraints()
    }

    @objc func searchButtonTapped(_ sender: UIButton) {
        if let urlString = enterLinkField.text, let url = URL(string: urlString) {
            fetchImagesFromURL(url: url) { [weak self] in
                DispatchQueue.main.async {
                    print(self!.imageDict)
                    let vc = ResultViewController()
                    vc.title = "LOOL"
                    let navVC = UINavigationController(rootViewController: vc)
                    self?.present(navVC, animated: true)
                }
            }
        } else {
            print("Некорректная ссылка")
        }
    }

    private func fetchImagesFromURL(url: URL, completion: @escaping () -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, let htmlString = String(data: data, encoding: .utf8) else {
                print("Error loading HTML: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                let doc = try SwiftSoup.parse(htmlString)
                let images = try doc.select("img").array()
                if images.isEmpty {
                    print("Страница не содержит изображений")
                } else {
                    for image in images {
                        let imageUrl = try image.attr("src")
//                        let imageSize = try image.attr("size")
                        if imageUrl.hasPrefix("http") {
                            self.imageDict.append(imageUrl)
                        }
                    }
                }
                completion() // Вызов блока завершения после получения данных
            } catch {
                print("Ошибка парсинга HTML: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    
    private func addConstraints() {
        enterLinkField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width - 30)
            make.height.equalTo(40)
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(enterLinkField.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
}


