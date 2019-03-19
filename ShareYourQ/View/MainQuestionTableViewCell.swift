//
//  MainQuestionTableViewCell.swift
//  ShareYourQ
//
//  Created by Furkan Beyhan on 15.03.2019.
//  Copyright © 2019 Furkan Beyhan. All rights reserved.
//

import UIKit

class MainQuestionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var questionImageView: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
