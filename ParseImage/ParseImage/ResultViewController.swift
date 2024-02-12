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
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = 10
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        addConstraints()
        scrollView.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        fetchInfo()
    }
    
    private func fetchInfo() {
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
                            
                            self.stackView.addArrangedSubview(imageView)
                            self.stackView.addArrangedSubview(label)
                            self.stackView.addArrangedSubview(sizeLabel)
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

    private func addConstraints() {
        scrollView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}


