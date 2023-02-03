//
//  MatchesVC.swift
//  FutsalleaguesX
//
//  Created by macOS on 02/02/23.
//

import UIKit
class cellMatch:UITableViewCell {
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
class MatchesVC: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var btnPast: UIButton!
    @IBOutlet weak var btnUpcoming: UIButton!
    @IBOutlet weak var tblMatch: UITableView!
    
    //MARK: - Global Variables
    var isPast = false
    var arrSelection = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var arrFilterMatches = [[String:Any]]()
    var arrAllMatches = [[String:Any]]()

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnPast.isSelected = true
        self.btnUpcoming.isSelected = false
        self.isPast = true
        self.tblMatch.reloadData()
    }
    
    //MARK: - IBActions
    @IBAction func btnPastAction(_ sender: Any) {
        self.btnPast.isSelected = true
        self.btnUpcoming.isSelected = false
        self.isPast = true
        self.api_getPastMatches()
    }
    @IBAction func btnUpcomingAction(_ sender: Any) {
        self.btnPast.isSelected = false
        self.btnUpcoming.isSelected = true
        self.isPast = false
        self.api_getUpcomingMatches()
    }
    @IBAction func btnIntrestAction(_ sender: UIButton) {
        if self.arrSelection[sender.tag] == 0 {
            self.arrSelection[sender.tag] = 1
        } else {
            self.arrSelection[sender.tag] = 0
        }
        self.tblMatch.reloadData()
    }
}

//MARK: - UITableViewDelegate,UITableViewDataSource
extension MatchesVC:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if self.arrAllMatches.count > 0
        {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No matches available"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrAllMatches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblMatch.dequeueReusableCell(withIdentifier: "cellMatch") as! cellMatch
        if self.isPast {
            if let objMatch =  self.arrAllMatches[indexPath.row] as? [String:Any] {
                if let homeTeam = objMatch["home"] as? [String:Any] {
                    cell.lblTeam1.text = homeTeam["name"] as? String ?? ""
                    cell.imgTeam1.sd_setImage(with: URL.init(string: "https://spoyer.com/api/team_img/soccer/" + "\(homeTeam["id"] as? String ?? "")" + ".png"), placeholderImage: UIImage.init(named: "ic_team_1_placeholder"))
                }
                if let awayTeam = objMatch["away"] as? [String:Any] {
                    cell.lblTeam2.text = awayTeam["name"] as? String ?? ""
                    cell.imgTeam2.sd_setImage(with: URL.init(string: "https://spoyer.com/api/team_img/soccer/" + "\(awayTeam["id"] as? String ?? "")" + ".png"), placeholderImage: UIImage.init(named: "ic_team_2_placeholder"))
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
        } else {
            if let objMatch =  self.arrAllMatches[indexPath.row] as? [String:Any] {
                if let homeTeam = objMatch["home"] as? [String:Any] {
                    cell.lblTeam1.text = homeTeam["name"] as? String ?? ""
                    cell.imgTeam1.sd_setImage(with: URL.init(string: "https://spoyer.com/api/team_img/soccer/" + "\(homeTeam["id"] as? String ?? "")" + ".png"), placeholderImage: UIImage.init(named: "ic_team_1_placeholder"))
                }
                if let awayTeam = objMatch["away"] as? [String:Any] {
                    cell.lblTeam2.text = awayTeam["name"] as? String ?? ""
                    cell.imgTeam2.sd_setImage(with: URL.init(string: "https://spoyer.com/api/team_img/soccer/" + "\(awayTeam["id"] as? String ?? "")" + ".png"), placeholderImage: UIImage.init(named: "ic_team_2_placeholder"))
                }
                if let startTimestamp = Int(objMatch["time"] as? String ?? "") {
                    let formaor = DateFormatter()
                    formaor.dateFormat = "dd.MM.yyyy"
                    cell.lblMatchDateTime.text = formaor.string(from: NSDate(timeIntervalSince1970: TimeInterval(truncating: NSNumber(value: startTimestamp))) as Date)
                    formaor.dateFormat = "hh:mm"
                    cell.lblMatchTime.text = formaor.string(from: NSDate(timeIntervalSince1970: TimeInterval(truncating: NSNumber(value: startTimestamp))) as Date)
                }
            }
        }
        cell.lblScore.isHidden = self.isPast ? false : true
        cell.imgVS.isHidden = self.isPast ? true : false
        cell.btnIntrest.tag = indexPath.row
        cell.btnIntrest.addTarget(self, action: #selector(self.btnIntrestAction(_:)), for: UIControl.Event.touchUpInside)
        cell.btnIntrest.isSelected = self.arrSelection[indexPath.row] == 1 ? true : false
        return cell
    }
}

//MARK: - API Calling
extension MatchesVC {
    func api_getPastMatches(){
        HttpRequestManager.shared.getRequest(
            requestURL:URL_Domain + "task=enddata&sport=soccer&league=" + APP_DELEGATE.Id,
            param:[:],
            showLoader:true)
        {(error,responseDict) -> Void in
            if error != nil {
                showMessageWithRetry(RetryMessage,3, buttonTapHandler: { _ in self.api_getPastMatches()
                })
                return
            } else if let dicData = responseDict, dicData.keys.count > 0 {
                if let arrTable = dicData["games_end"] as? [[String:Any]] {
                    self.arrAllMatches.removeAll()
                    self.arrAllMatches.append(contentsOf: arrTable)
                    self.tblMatch.reloadData()
                }
            }
        }
    }
    
    func api_getUpcomingMatches(){
        HttpRequestManager.shared.getRequest(
            requestURL:URL_Domain + "task=predata&sport=soccer&league=" + APP_DELEGATE.Id,
            param:[:],
            showLoader:true)
        {(error,responseDict) -> Void in
            if error != nil {
                showMessageWithRetry(RetryMessage,3, buttonTapHandler: { _ in self.api_getUpcomingMatches()
                })
                return
            } else if let dicData = responseDict, dicData.keys.count > 0 {
                if let arrTable = dicData["games_pre"] as? [[String:Any]] {
                    self.arrAllMatches.removeAll()
                    self.arrAllMatches.append(contentsOf: arrTable)
                    self.tblMatch.reloadData()
                }
            }
        }
    }
}
