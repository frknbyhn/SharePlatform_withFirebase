//
//  DetailViewController.swift
//  ShareYourQ
//
//  Created by Furkan Beyhan on 18.03.2019.
//  Copyright © 2019 Furkan Beyhan. All rights reserved.
//

import UIKit
import Kingfisher
import FirebaseDatabase

protocol HomeRefresherDelegate : class {
    
    func refreshNeed(needed: Bool)
    
}

class DetailViewController: UIViewController {
    
    var questions : Question?
    var comingIndex : Int?
    
    weak var delegate : HomeRefresherDelegate?
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var answerField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionLabel.text = questions?.answerDesc
        detailImageView.kf.setImage(with: URL(string: (questions?.questionUrl)!))
        answerLabel.text = questions?.answerLabel
        
    }

    @IBAction func sendButton(_ sender: Any) {
        
        let questionRef = Database.database().reference().child("questions").child("\(comingIndex!)")
            questionRef.updateChildValues(["answerLabel" : answerField.text!])
            answerLabel.text = answerField.text
        
        self.dismiss(animated: true, completion: {
            self.delegate?.refreshNeed(needed: true)
        })
        
    }
    
    @IBAction func crossButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: {
            self.delegate?.refreshNeed(needed: true)
        })
        
    }
    
}
