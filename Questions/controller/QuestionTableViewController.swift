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
import DropDown

class QuestionTableViewController: UITableViewController {
    
    
    var selectedCategory : Category?
    var array = [String]()
    var array1 = [String]()
    
    var countOfQuestions : Int = 0
    @IBOutlet weak var press: UIBarButtonItem!
    let dropDown = DropDown()
    let URL_ByCategory = "http://10.177.1.100:8080/question/getByCategoryId/"
    let URL_All = "http://10.177.1.100:8080/question/getAll"
    let URL_ByCategoryByPage = "http://10.177.1.100:8080/question/getByCategoryId/"
    var questions = [Question]()
    var questionsByCategory = [Question]()
    var selectedItem = "1"
    @IBAction func press1(_ sender: AnyObject) {
        
        dropDown.show()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDropDown()
        dropDown.dismissMode = .onTap
        dropDown.direction = .any
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectedItem = item
            self.press.title = self.selectedItem
            self.loadItems()
        }
        loadItems()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory!.categoryName
        press.title = selectedItem
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  questions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath)
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
            }
            else{
                print("\(String(describing: response.result.error))")
            }
        }
    }
    func getQuestionByCategoryIdAndPage(url:String,categoryId:String,pageNumber: String){
        var url1 : String = ""
        url1 = url + "/" + categoryId + "/" + pageNumber
        Alamofire.request(url1, method: .get).responseJSON{
            response in
            if response.result.isSuccess{
                print("Got the data by category and page")
                let questionByCategoryJSON : JSON = JSON(response.result.value!)
                // print(questionJSON)
                if  let data = try? questionByCategoryJSON.rawData(), let decoder = try? JSONDecoder().decode([Question].self, from: data){
                    //            print(decoder)
                    self.questions = decoder
                    
                }
                //print(questions)
                self.tableView.reloadData()
            }
            else{
                print("\(String(describing: response.result.error))")
            }
        }
    }
    
    func getQuestionByCategoryId(url:String,categoryId:String,completion: @escaping ((Int)->Void)){
        let url1 = url + "/" + categoryId
        
        Alamofire.request(url1, method: .get).responseJSON{
            response in
            if response.result.isSuccess{
                print("Got the data by category id")
                let questionByCategoryJSON1 : JSON = JSON(response.result.value!)
                //print(questionByCategory)
                if  let data = try? questionByCategoryJSON1.rawData(), let decoder = try? JSONDecoder().decode([Question].self, from: data){
                    //   print(decoder)
                    self.questionsByCategory = decoder
                    completion(self.questionsByCategory.count)
                }
                
            }
            else{
                print("\(String(describing: response.result.error))")
            }
        }
    }
    
    func loadItems(){
        let categoryIdNew = selectedCategory?.categoryId
        
        if let categoryIdNewL = categoryIdNew{
            getQuestionByCategoryIdAndPage(url: URL_ByCategoryByPage, categoryId: categoryIdNewL,pageNumber: selectedItem)
            
            self.tableView.reloadData()
        }
        
    }
    func setupDropDown(){
        let categoryIdNew = self.selectedCategory?.categoryId
        if let categoryIdNewL = categoryIdNew{
            
            getQuestionByCategoryId(url: URL_ByCategory, categoryId: categoryIdNewL) { (count) in
                let remainder_ = count%10
                var count1 = 0
                if remainder_ != 0{
                    count1 = (count + 10)/10
                }
                else
                {
                    count1 = count/10
                }
                var a = 1
                let d = 1
                while (a <= count1) {
                    self.array.append(String(a))
                    a = a + d
                }
                self.dropDown.anchorView = self.press
                self.dropDown.dataSource = self.array
                print(self.array)
            }
        }
    }
}

