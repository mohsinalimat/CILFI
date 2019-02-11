//
//  NewsLetterViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on ੩੦/੧੧/੧੮.
//  Copyright © ੨੦੧੮ Focus Infosoft. All rights reserved.
//

import UIKit
import Cards
import Alamofire
import SwiftyJSON
import SDWebImage
import McPicker
import SVProgressHUD

class NewsCell : UITableViewCell{
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var time: UILabel!
    
    
    
}

class NewsLetterViewController: UIViewController {

    struct News {
        var author : String?
        var content : String?
        var title : String?
        var url : String?
        var imgUrl : String?
        var source : String?
        var pulishedAt : String?
    }
    
  var url = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    var news = [News]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//category-glyph-icon
        tableView.dataSource = self
        tableView.delegate = self
         getNews(url: "https://newsapi.org/v2/top-headlines?country=in&apiKey=f31652caa24f42708bf1f09afae9a05c")
        
//        let rightButtonItem :UIBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "category-glyph-icon"), style:.plain, target: self, action: #selector(self.rightButtonTapped))
        let rightButtonItem :UIBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "category-glyph-icon"), style:.plain, target: self, action: #selector(rightButtonTapped))
        rightButtonItem.tintColor = UIColor.black
        navigationItem.rightBarButtonItems = [ rightButtonItem]
        SVProgressHUD.show()
    }
    
    @objc func rightButtonTapped(){
        McPicker.show(data: [["Top Headlines","Business", "Entertainment", "Health", "Science", "Sports", "Technology" ]]) {  [weak self] (selections: [Int : String]) -> Void in
            if let name = selections[0] {
                SVProgressHUD.show()
                switch name.lowercased(){
                    case "business" : self!.getNews(url: "https://newsapi.org/v2/top-headlines?country=in&category=business&apiKey=f31652caa24f42708bf1f09afae9a05c")
                    case "top headlines" : self!.getNews(url: "https://newsapi.org/v2/top-headlines?country=in&apiKey=f31652caa24f42708bf1f09afae9a05c")
                    case "entertainment" : self!.getNews(url: "https://newsapi.org/v2/top-headlines?country=in&category=entertainment&apiKey=f31652caa24f42708bf1f09afae9a05c")
                    case "health" : self!.getNews(url: "https://newsapi.org/v2/top-headlines?country=in&category=health&apiKey=f31652caa24f42708bf1f09afae9a05c")
                    case "science" : self!.getNews(url: "https://newsapi.org/v2/top-headlines?country=in&category=science&apiKey=f31652caa24f42708bf1f09afae9a05c")
                    case "sports" : self!.getNews(url: "https://newsapi.org/v2/top-headlines?country=in&category=sports&apiKey=f31652caa24f42708bf1f09afae9a05c")
                    case "technology" : self!.getNews(url: "https://newsapi.org/v2/top-headlines?country=in&category=technology&apiKey=f31652caa24f42708bf1f09afae9a05c")
                    default : SVProgressHUD.showInfo(withStatus: "Invalid Selection")
                }
            }
        }
        
    }
    
    func getNews(url : String){
        
        news = [News]()
        
        Alamofire.request(url, method: .get).responseJSON{
            response in
            
            let newsData = response.data!
            let dashJSON = response.result.value
            
            if response.result.isSuccess{
//                print("dashJSON: \(dashJSON)")
                do{
                     let dash = try JSONDecoder().decode(NewsFeedRoot.self, from: newsData)
                    
                    if dash.status?.lowercased() == "ok"{
                        for x in dash.articles{
                            var source = ""
//                            for y in x.source{
//                                if let value = y.name{
//                                    source = value
//                                }
//                            }
                            
                            
                            self.news.append(News(author: x.author, content: x.content, title: x.title, url: x.url, imgUrl: x.urlToImage, source: source , pulishedAt: x.publishedAt))
                        }
                    }
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                }catch{
                    print (error)
                }
            }
            else{
                print("Something Went wrong")
            }
        }
    }
}


extension NewsLetterViewController : UITableViewDelegate, UITableViewDataSource{
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nCell", for: indexPath) as! NewsCell
        
        cell.img.sd_setImage(with: URL(string:  news[indexPath.row].imgUrl ?? ""))
    
        cell.title.text = news[indexPath.row].title ?? ""
        cell.time.text = news[indexPath.row].pulishedAt ?? ""
//        cell.news.text = news[indexPath.row].content ?? ""
        
        tableView.layoutIfNeeded()
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count ?? 1
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "goToURL", sender: self)
        url = news[indexPath.row].url ?? "about:blank"
        print(url)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToURL"{
            
//            let vc = segue.destination as! NewsLetterURLViewController
//            if url != ""{
//            if let stringToURL = URL(string:url){
//                vc.webView.load(URLRequest(url: stringToURL))
//            }
//            }}
        }}
    
}
