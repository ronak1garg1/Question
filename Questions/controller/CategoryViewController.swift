//
//  CategoryViewController.swift
//  Questions
//
//  Created by RONAK GARG on 17/07/18.
//  Copyright © 2018 Coviam. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class CategoryViewController : UITableViewController{
    
    
    var categories = [Category]()
    let URL_CATEGORY = "http://10.177.1.100:8080/question/category/getAll"
    override func viewDidLoad() {
        super.viewDidLoad()
        getCategoryData(url: URL_CATEGORY)
        tableView.reloadData()
        tableView.rowHeight = 80
        
        
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell",for:indexPath)
        cell.textLabel?.text = categories[indexPath.row].categoryName
        cell.textLabel?.numberOfLines = 0
        self.tableView.deselectRow(at: indexPath, animated: true)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToQuestions", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! QuestionTableViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    func getCategoryData(url:String){
        Alamofire.request(url,method:.get).responseJSON{
            response in
            if response.result.isSuccess{
                print("Got Category Data")
                let categoryJSON : JSON = JSON(response.result.value)
                self.updateCategories(json: categoryJSON)
            }
            else
            {
                print("\(response.result.error)")
            }
            
        }
        
    }
    func updateCategories(json:JSON){
        if let data = try? json.rawData(),let decoder = try? JSONDecoder().decode([Category].self, from: data){
           // print(decoder)
            categories = decoder
        }
        // print(categories)
        tableView.reloadData()
    }
}
