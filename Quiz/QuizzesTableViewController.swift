//
//  QuizzesTableViewController.swift
//  Quiz
//
//  Created by Rebeca Nicole on 24/11/2018.
//  Copyright © 2018 Rebeca Nicole. All rights reserved.
//

import UIKit

class QuizzesTableViewController: UITableViewController {
    
    var quizzes = [[String: Any]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        downloadQuizzes()
    }
    
    func downloadQuizzes() {
        
        let queue = DispatchQueue(label: "Download Queue")
        queue.async {
            var query = "https://quiz2019.herokuapp.com/api/quizzes?token=d4d596910885ba5cefe1"
          
            self.title = "Downloading ..."
            
            while query != "" {
                
                
                if let pageURL = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    
                    //print("URL = \(pageURL)")
                    
                    if let url = URL(string: pageURL) {
                        
                        if let data = try? Data(contentsOf: url),
                            let jsonData = try? JSONSerialization.jsonObject(with: data) as? [String: Any]{
                            //print(jsonData)
                            let nextURL = jsonData?["nextUrl"] as? String
                            query = nextURL!
                            //print("///////////////////")
                            //print("NextURL: \(nextURL!)")
                            let downloadedQuizzes = jsonData?["quizzes"] as? [[String: Any]]
                            //print(downloadedQuizzes)
                            DispatchQueue.main.async {
                                if (downloadedQuizzes?.count != 0) {
                                    self.quizzes+=(downloadedQuizzes ?? [])
                                    //print("///////////////////")
                                    //print(self.quizzes)
                                } else {
                                    self.tableView.reloadData()
                                    return
                                }
                            }
                            
                        } else {
                            print("ERROOOOOOOOOOOR")
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.title = "All Quizzes"
            }
            //print(self.quizzes)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return quizzes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quiz cell", for: indexPath) as! QuizTableViewCell
        
        let quiz = quizzes[indexPath.row]
        if let author = quiz["author"] as? [String: Any] {
            if let user = author["username"] as? String{
                cell.AuthorLabel.text = "by: \(user)"
            }
        }
        
        if let attachment = quiz["attachment"] as? [String: Any] {
            if let imageURL = attachment["url"] as? String{
                if let imgescapedURL = imageURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    if let url = URL(string: imgescapedURL) {
                        if let data = try? Data(contentsOf: url),
                            // Construir una imagen con los datos bajados
                            let img = UIImage(data: data){
                            cell.Picture.image = img
                        }
                    }
                }
            }
        }
        
        if let question = quiz["question"] as? String {
            cell.QuestionLabel.text = question
        }
        
        if let favourite = quiz["favourite"] as? Int {
            if (favourite==1){
                let yellowImg = UIImage(named: "star_yellow")
                cell.FavOutlet.setImage(yellowImg, for: UIControl.State.normal)
            }
        }
        
        if let id = quiz["id"] as? Int {
            cell.quizId = id
        }
        
        return cell
    }
   

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ask question" {
            if let avc = segue.destination as? AskQuestionViewController{
                if let inpath = tableView.indexPathForSelectedRow {
                    let quiz = quizzes[inpath.row]
                    if let question = quiz["question"] as? String {
                        avc.question = question
                    }
                    if let attachment = quiz["attachment"] as? [String: Any] {
                        if let imageURL = attachment["url"] as? String{
                            if let imgescapedURL = imageURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                                if let url = URL(string: imgescapedURL) {
                                    if let data = try? Data(contentsOf: url),
                                        // Construir una imagen con los datos bajados
                                        let img = UIImage(data: data){
                                        avc.photo = img
                                    }
                                }
                            }
                        }
                    }
                    
                    if let tips = quiz["tips"] as? [String] {
                        avc.tips=tips
                        //print(tips)
                    }
                    if let id = quiz["id"] as? Int {
                        avc.id = id
                    }
                    
                }
            }
        }
        
    }
    

}
