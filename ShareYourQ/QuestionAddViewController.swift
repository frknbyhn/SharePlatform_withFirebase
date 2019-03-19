//
//  QusetionAddViewController.swift
//  ShareYourQ
//
//  Created by Furkan Beyhan on 15.03.2019.
//  Copyright © 2019 Furkan Beyhan. All rights reserved.
//

import UIKit
import MobileCoreServices
import FirebaseStorage
import FirebaseDatabase


class QuestionAddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var uploadProgressBar: UIProgressView!
    @IBOutlet weak var percentageLabel: UILabel!
    
    @IBOutlet weak var questionImageView: UIImageView!
    @IBOutlet weak var answerTextField: UITextField!
    
    var newPic : Bool?
    var questions : Question?
    var items : Int = 0
    
    weak var delegate : HomeRefresherDelegate?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        uploadProgressBar.setProgress(0, animated: false)
        uploadProgressBar.isHidden = true
        percentageLabel.isHidden = true
        
    }

    @IBAction func quitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendButton(_ sender: Any) {
        uploadProgressBar.isHidden = false
        percentageLabel.isHidden = false
        if percentageLabel.text == "Upload Finished"{
            percentageLabel.text = "You can upload new file now"
        }
        
        let ref = Database.database().reference().child("questions")
        ref.observe(.value, with: {(snapshot : DataSnapshot!) in
            self.items = Int(snapshot.childrenCount)
            self.items = self.items + 1
            print(self.items)

        })
        
        let key = Database.database().reference().child("questions").childByAutoId().key
        
        
        let dataRef = Database.database().reference().child("questions").child(key!)
        let storageRef = Storage.storage().reference().child("\(items).jpeg")
        
        let uploadObject = questionImageView.image!.jpegData(compressionQuality: 1.0)
        let progress = storageRef.putData(uploadObject!, metadata: nil)

        storageRef.putData(uploadObject!, metadata: nil) { (metadata, error) in
            if error != nil{
                print(error!)
                return
            }else{
                progress.observe(.progress){ snapshot in
                    let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
                    print(percentComplete)
                    self.uploadProgressBar.setProgress(Float(percentComplete/100), animated: true)
                    let roundedPercentage = String(percentComplete.rounded())
                    self.percentageLabel.text = "%\(roundedPercentage)"
                }
            }
            
            progress.observe(.success) { snapshot in
                let alert = UIAlertController(title: "Congrats", message: "Your question upload succesfully", preferredStyle: .alert)
                let okay = UIAlertAction(title: "Back to the main page", style: .default, handler: { (action) in
                    self.uploadProgressBar.setProgress(0, animated: true)
                    self.percentageLabel.text = "Upload Complete"
                    self.questionImageView.image = #imageLiteral(resourceName: "launch")
                    self.answerTextField.text = ""
                })
                
                alert.addAction(okay)
                self.present(alert, animated: true, completion: nil)
            }
            
            
            storageRef.downloadURL(completion: { (url, error) in
                if error != nil{
                    print(error!)
                }else{
                    let newQuestion = [
                        "answerLabel" : "Question \(self.items)" ,
                        "answerDescription" : self.answerTextField.text! as String,
                        "questionUrl" : "\(url!)"
                    ]
                    dataRef.setValue(newQuestion)
                }
            })
        
        }
        }
    
    @IBAction func takePhotoButton(_ sender: Any) {
        let alert = UIAlertController(title: "Select image from", message: "", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
                self.newPic = true
            }
        }
        let cameraRollAction = UIAlertAction(title: "Camera Roll", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
                self.newPic = false
            }
        }
        alert.addAction(cameraRollAction)
        alert.addAction(cameraAction)
        self.present(alert, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        if mediaType.isEqual(to: kUTTypeImage as String){
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            questionImageView.image = image
            if newPic == true{
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageError), nil)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func imageError(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafeRawPointer){
        if error != nil{
            let alert = UIAlertController(title: "Save Failed", message: "Failed to save image", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    }

