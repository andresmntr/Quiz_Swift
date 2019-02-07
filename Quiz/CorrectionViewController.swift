//
//  CorrectionViewController.swift
//  Quiz
//
//  Created by Rebeca Nicole on 24/11/2018.
//  Copyright © 2018 Rebeca Nicole. All rights reserved.
//

import UIKit

class CorrectionViewController: UIViewController {
    
    var answer : String?
    var id : Int?
    
    fileprivate struct ResponseObject: Codable {
        let quizId: Int?
        let answer: String?
        let result: Bool?
    }

    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        checkAnswer()
    }
    
    func checkAnswer() {
        let queue = DispatchQueue(label: "Download Queue")
        queue.async {
            let query = "https://quiz2019.herokuapp.com/api/quizzes/\(self.id!)/check?token=d4d596910885ba5cefe1&answer=\(self.answer!)"
            
            //print(query)
            
            if let pageURL = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                
                //print("URL = \(pageURL)")
                
                if let url = URL(string: pageURL) {
                    
                    if let data = try? Data(contentsOf: url) {
                        
                        if let jsonData = try? JSONSerialization.jsonObject(with: data) as? [String: Any]{
                            //print(jsonData)
                            let result = jsonData?["result"] as? Bool
                            //                        let
                            DispatchQueue.main.async {
                                if (result ?? false) {
                                    self.resultLabel.text = "Respuesta CORRECTA"
                                    return
                                }
                                else {
                                    self.resultLabel.text = "Respuesta INCORRECTA"
                                    return
                                }
                            }
                        } else {
                            print("ERROOOOOOOOOOOR")
                        }
                    }
                }
            }
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
