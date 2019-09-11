//
//  LYHomeVCTableViewCell.swift
//  Loyalty
//
//  Created by Krishnamoorthy on 17/07/17.
//  Copyright © 2017 Krishnamoorthy. All rights reserved.
//

import UIKit

class LYHomeVCTableViewCell: UITableViewCell {

    @IBOutlet weak var img_imageView: UIImageView!
    
    @IBOutlet weak var view_BackgroundView: UIView!
    @IBOutlet weak var lbl_titleName: UILabel!
    @IBOutlet weak var lbl_subTitleName: UILabel!
    @IBOutlet weak var TenPercentageImage: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
