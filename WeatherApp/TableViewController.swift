//
//  TableViewController.swift
//  WeatherApp
//
//  Created by 梶原敬太 on 2019/06/15.
//  Copyright © 2019 梶原敬太. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class TableViewController: UITableViewController {
    
    
    
    //都道府県一覧
    var prefectures: [Pref] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Alamofireを利用して通信を行います。Alamofire.requestという関数で通信してデータを受け取っている
        Alamofire.request("https://script.google.com/macros/s/AKfycbyFEiNBHOJcs5pGhh1JuKsK17moh3C6TDHD31Gk01NCPcZcwdcA/exec").responseJSON { (response: DataResponse<Any>) in
            
            if response.result.isFailure == true {
                
                self.simpleAlert(title: "通信エラー", message: "通信に失敗しました")
                return
            }
            
            // "guard let 変数 〜 else" で変数の中身がnilの場合のみの処理が書けます。
            // ただし最後に必ずreturnで関数を終了させなければいけません。
            // 変数は以後の関数内でも利用できます。
            //返ってきた結果がnil じゃなかったら    nilだったら できないときはアラートを表示
            guard let val = response.result.value as? [String: Any] else {
                self.simpleAlert(title: "通信エラー", message: "通信結果がJSONではありませんでした")
                return
                
            }
            
            // responseJSONを使うと辞書形式でも扱えますが、今回はより簡単に扱うためにSwiftyJSONを利用します。
            let json = JSON(val)
            
            // 取得データを扱いやすいデータに変更
            let prefJSON = json["rss"]["channel"]["source"]["pref"].arrayValue
            
            self.prefectures = prefJSON.map({(item:JSON) in
                return Pref(pref: item)
            })
            
            
            // テーブルにデータを反映
            self.tableView.reloadData()
            
            // 確認用
            print(prefJSON)
            
            
            
        }
        
        
    }
    
    
    func simpleAlert(title:String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //アクションを作る
        alert.addAction(UIAlertAction(title: "閉じる", style: .cancel, handler: nil))
        //アラートを表示
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return prefectures.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        let cities = prefectures[section].cities
        
        return cities.count
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return prefectures[section].title
        
        
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "prefCell", for: indexPath) as! TableViewCell
        
        
        
        cell.titleLabel.text = prefectures[indexPath.section].cities[indexPath.row].title
        cell.idlabel.text = prefectures[indexPath.section].cities[indexPath.row].id
        
        
        // Configure the cell...
        
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
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
    // 画面遷移時に地域IDを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 遷移先がDetailViewControllerであること
        if let detailVC = segue.destination as? DetailViewController {
            //押されたセルの情報がセンダーにはいった
            // 選択したセルが持つIDを取得し、遷移先に渡す
            if let cell = sender as? TableViewCell, let indexPath = tableView.indexPath(for: cell) {
                detailVC.cityID = prefectures[indexPath.section].cities[indexPath.row].id
            }
        }
        
    }
}
