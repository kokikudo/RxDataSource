//
//  ColorBGViewController.swift
//  RxDataSource
//
//  Created by kudo koki on 2023/03/11.
//

import UIKit

class ColorBGViewController: UIViewController {
    
    let theLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.textAlignment = .center
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(theLabel)
        NSLayoutConstraint.activate([
            theLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            theLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            theLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
        ])
    }
}
