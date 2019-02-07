//
//  AskQuestionViewController.swift
//  Quiz
//
//  Created by Rebeca Nicole on 24/11/2018.
//  Copyright © 2018 Rebeca Nicole. All rights reserved.
//

import UIKit

class AskQuestionViewController: UIViewController {

    var question : String = ""
    var photo : UIImage?
    var tips : [String]?
    var id : Int?
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerText: UITextField!
    @IBOutlet weak var picture: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "Answer the question"
        updateQuiz()
    }
    
    func updateQuiz(){
        questionLabel.text = question
        picture.image = photo
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "show tips" {
            if let tvc = segue.destination as? TipsTableViewController {
                tvc.tips = tips
            }
            
        }
        
        if segue.identifier == "check answer" {
            if let cvc = segue.destination as? CorrectionViewController{
                if let answer = answerText.text {
                    cvc.answer = answer
                    //print(answer)
                }
                cvc.id = id
            }
        }
        
    }
    

}
