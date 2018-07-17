//
//  ViewController.swift
//  Questions
//
//  Created by RONAK GARG on 16/07/18.
//  Copyright © 2018 Coviam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class QuestionTableViewController: UITableViewController {
    
    let URL_All = "http://10.177.1.100:8080/question/getAll/"
    var questions = [Question]()
    override func viewDidLoad() {
        super.viewDidLoad()
        getQuestionData(url: URL_All)
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  questions.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath)
//        cell.textLabel.te
        
        cell.textLabel?.text = questions[indexPath.row].questionText
        cell.textLabel?.numberOfLines = 0
     
        return cell
    }
    func getQuestionData(url: String){
        Alamofire.request(url, method: .get).responseJSON{
            response in
            if response.result.isSuccess{
                print("Got the data")
                let questionJSON : JSON = JSON(response.result.value!)
                // print(questionJSON)
                self.updateQuestions(json: questionJSON)
            }
            else{
                print("\(String(describing: response.result.error))")
            }
        }
    }
    
    func updateQuestions(json:JSON){
        if  let data = try? json.rawData(), let decoder = try? JSONDecoder().decode([Question].self, from: data){
            //            print(decoder)
            questions = decoder
            
        }
        tableView.reloadData()
    }
}

