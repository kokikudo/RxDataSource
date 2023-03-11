//
//  PageIconCollectionViewCell.swift
//  RxDataSource
//
//  Created by kudo koki on 2023/03/11.
//

import UIKit

class PageIconCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    static let identifier = "PageIconCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func update(iconImage: UIImage) {
        imageView.image = iconImage
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
    }
}
