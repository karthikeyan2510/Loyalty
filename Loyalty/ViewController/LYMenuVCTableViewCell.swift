//
//  LYMenuVCTableViewCell.swift
//  Loyalty
//
//  Created by Krishnamoorthy on 17/07/17.
//  Copyright © 2017 Krishnamoorthy. All rights reserved.
//

import UIKit

class LYMenuVCTableViewCell: UITableViewCell
{
    @IBOutlet weak var img_MenuImage: UIImageView!
    @IBOutlet weak var lbl_MenuName: UILabel!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
