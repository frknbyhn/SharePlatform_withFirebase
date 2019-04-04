//
//  ViewController.swift
//  ShareYourQ
//
//  Created by Furkan Beyhan on 15.03.2019.
//  Copyright © 2019 Furkan Beyhan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Kingfisher



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HomeRefresherDelegate {
    
    func refreshNeed(needed: Bool) {
        if needed {
            questions.removeAll()
            webReq()
        }
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var questions = [Question]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webReq()
        self.tableView.register(UINib(nibName: "MainQuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "mainPage")
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
    func webReq(){
        let questionRef = Database.database().reference().child("questions")
        questionRef.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let questionDict = snap.value as! [String:Any]
                let question = Question()
                question.answerDesc = questionDict["answerDescription"] as! String
                question.questionUrl = questionDict["questionUrl"] as! String
                question.answerLabel = questionDict["answerLabel"] as! String
                self.questions.append(question)
                self.tableView.reloadData()
            }
        }
    }
        
        
    
    
    
    @IBAction func addButton(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "questionPage") as! QuestionAddViewController
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "questionDetail") as! DetailViewController
        vc.questions = self.questions[indexPath.row]
        vc.comingIndex = indexPath.row + 1
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return questions.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainPage", for: indexPath) as! MainQuestionTableViewCell
        cell.questionLabel.text = questions[indexPath.row].answerDesc
        cell.questionImageView.kf.setImage(with: URL(string: questions[indexPath.row].questionUrl))
        cell.answerLabel.text = questions[indexPath.row].answerLabel
        return cell
        
    }
    
}




