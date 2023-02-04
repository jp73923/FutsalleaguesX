//
//  IntrestVC.swift
//  FutsalleaguesX
//
//  Created by macOS on 02/02/23.
//

import UIKit
class cellIntrestMatch:UITableViewCell {
    //MARK: - IBOutlets
    @IBOutlet weak var imgVS: UIImageView!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var btnIntrest: UIButton!
    @IBOutlet weak var lblMatchDateTime: UILabel!
    @IBOutlet weak var lblMatchTime: UILabel!
    @IBOutlet weak var lblTeam1: UILabel!
    @IBOutlet weak var lblTeam2: UILabel!
    @IBOutlet weak var imgTeam1: UIImageView!
    @IBOutlet weak var imgTeam2: UIImageView!
}
class IntrestVC: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var tblIntrest: UITableView!
    
    //MARK: - Global Variables

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - IBActions
    @IBAction func btnIntrestAction(_ sender: UIButton) {
        let userDefaults = UserDefaults.standard
        if let arr = userDefaults.value(forKey: UD_IdFavourite) as? [String]{
            var array = [String]()
            array = arr
            if let gameId = arr[sender.tag] as? String {
                if let index = array.index(of: gameId) {
                    array.remove(at: index)
                    if let arr = UserDefaultManager.getCustomArrayFromUserDefaults(key: UD_Favourite) as? NSMutableArray, arr.count > 0 {
                        arr.removeObject(at: index)
                        UserDefaultManager.setCustomArrayToUserDefaults(array: arr, key: UD_Favourite)
                    }
                }
                userDefaults.set(array, forKey: UD_IdFavourite)
            }
        }
        self.tblIntrest.reloadData()
    }
}

//MARK: - UITableViewDelegate,UITableViewDataSource
extension IntrestVC:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let arr = UserDefaultManager.getCustomArrayFromUserDefaults(key: UD_Favourite) as? [[String:Any]], arr.count > 0 {
            var numOfSection: NSInteger = 0
            if arr.count > 0 {
                self.tblIntrest.backgroundView = nil
                numOfSection = 1
            } else {
                let noDataLabel: UILabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: self.tblIntrest.bounds.size.width, height: self.tblIntrest.bounds.size.height))
                noDataLabel.text = "No intresting matches found"
                noDataLabel.textColor = UIColor.white
                noDataLabel.textAlignment = NSTextAlignment.center
                self.tblIntrest.backgroundView = noDataLabel
            }
            return numOfSection
        } else {
            let noDataLabel: UILabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: self.tblIntrest.bounds.size.width, height: self.tblIntrest.bounds.size.height))
            noDataLabel.text = "No intresting matches found"
            noDataLabel.textColor = UIColor.white
            noDataLabel.textAlignment = NSTextAlignment.center
            self.tblIntrest.backgroundView = noDataLabel
            return 0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let arr = UserDefaultManager.getCustomArrayFromUserDefaults(key: UD_Favourite) as? [[String:Any]], arr.count > 0 {
            return arr.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblIntrest.dequeueReusableCell(withIdentifier: "cellIntrestMatch") as! cellIntrestMatch
        if let arr = UserDefaultManager.getCustomArrayFromUserDefaults(key: UD_Favourite) as? [[String:Any]], arr.count > 0 {
            if let objMatch = arr[indexPath.row] as? [String:Any] {
                if let homeTeam = objMatch["home"] as? [String:Any] {
                    cell.lblTeam1.text = homeTeam["name"] as? String ?? ""
                    cell.imgTeam1.sd_setImage(with: URL.init(string: "https://spoyer.com/api/team_img/futsal/" + "\(homeTeam["id"] as? String ?? "")" + ".png"), placeholderImage: UIImage.init(named: "ic_team_1_placeholder"))
                }
                if let awayTeam = objMatch["away"] as? [String:Any] {
                    cell.lblTeam2.text = awayTeam["name"] as? String ?? ""
                    cell.imgTeam2.sd_setImage(with: URL.init(string: "https://spoyer.com/api/team_img/futsal/" + "\(awayTeam["id"] as? String ?? "")" + ".png"), placeholderImage: UIImage.init(named: "ic_team_2_placeholder"))
                }
                cell.lblScore.text = objMatch["score"] as? String ?? ""
                if let startTimestamp = Int(objMatch["time"] as? String ?? "") {
                    let formaor = DateFormatter()
                    formaor.dateFormat = "dd.MM.yyyy"
                    cell.lblMatchDateTime.text = formaor.string(from: NSDate(timeIntervalSince1970: TimeInterval(truncating: NSNumber(value: startTimestamp))) as Date)
                    formaor.dateFormat = "hh:mm"
                    cell.lblMatchTime.text = formaor.string(from: NSDate(timeIntervalSince1970: TimeInterval(truncating: NSNumber(value: startTimestamp))) as Date)
                }
            }
        }
        cell.btnIntrest.tag = indexPath.row
        cell.btnIntrest.addTarget(self, action: #selector(self.btnIntrestAction(_:)), for: UIControl.Event.touchUpInside)
        cell.btnIntrest.isSelected = true
        return cell
    }
}
