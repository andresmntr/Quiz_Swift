//
//  QuizTableViewCell.swift
//  Quiz
//
//  Created by Rebeca Nicole on 24/11/2018.
//  Copyright © 2018 Rebeca Nicole. All rights reserved.
//

import UIKit

class QuizTableViewCell: UITableViewCell {

    var quizId: Int?
    
    @IBOutlet weak var AuthorLabel: UILabel!
    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var Picture: UIImageView!
    @IBOutlet weak var FavOutlet: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func FavButton(_ sender: UIButton) {
        let greyImg = UIImage(named: "star_grey")
        if FavOutlet.image(for: UIControl.State.normal)==greyImg{
            putFavourite(quizId: quizId!, method: "PUT")
            let yellowImg = UIImage(named: "star_yellow")
            FavOutlet.setImage(yellowImg, for: UIControl.State.normal)
            
        }else{
            putFavourite(quizId: quizId!, method: "DELETE")
            FavOutlet.setImage(greyImg, for: UIControl.State.normal)
        }
        
    }
    
    func putFavourite(quizId: Int, method: String){
        let queue = DispatchQueue(label: "Fav Queue")
        queue.async {
            
            let query = "https://quiz2019.herokuapp.com/api/users/tokenOwner/favourites/\(quizId)?token=d4d596910885ba5cefe1"
            if let pageURL = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                
                //print("URL = \(pageURL)")
                
                if let url = URL(string: pageURL) {
                    var request = URLRequest(url: url)
                    request.httpMethod = method
                    let session = URLSession.shared
                    let task = session.dataTask(with: request) { (data, response, error) in
//                        if let response = response {
//                            print(response)
//                        }
                        let code = (response as! HTTPURLResponse).statusCode
                        if code != 200 {
                            print("//////////////////////")
                            print(HTTPURLResponse.localizedString(forStatusCode: code))
                            return
                        }
                         //print("YESSSSS")
                    }
                    task.resume()
                }
            }
        }
    }
    

}
