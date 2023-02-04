//
//  TableVC.swift
//  FutsalleaguesX
//
//  Created by macOS on 02/02/23.
//

import UIKit
class cellPlus:UITableViewCell {
    //MARK: - IBOutlets
    @IBOutlet weak var imgTeam: UIImageView!
    @IBOutlet weak var lblTeamName: UILabel!
    @IBOutlet weak var lblScorePG: UILabel!
    @IBOutlet weak var lblScoreG: UILabel!
    @IBOutlet weak var lblScorePTS: UILabel!
}
class cellMinus:UITableViewCell {
    //MARK: - IBOutlets
    @IBOutlet weak var imgTeam: UIImageView!
    @IBOutlet weak var lblScorePG: UILabel!
    @IBOutlet weak var lblScoreG: UILabel!
    @IBOutlet weak var lblScorePTS: UILabel!
    @IBOutlet weak var lblScoreW: UILabel!
    @IBOutlet weak var lblScoreL: UILabel!
    @IBOutlet weak var lblScoreD: UILabel!
    @IBOutlet weak var lblScoreCH: UILabel!
}
class TableVC: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var vwPlus: UIView!
    @IBOutlet weak var vwMinus: UIView!
    @IBOutlet weak var btnPlusMinus: UIButton!
    @IBOutlet weak var tblTable: UITableView!
    @IBOutlet weak var imgTopTeam: UIImageView!
    
    //MARK: - Global Variables
    var arrTableLeague = [[String:Any]]()

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.api_getLeagueTableList()
    }
    
    //MARK: - IBActions
    @IBAction func btnPlusMinusAction(_ sender: UIButton) {
        if self.vwMinus.isHidden == false {
            self.vwMinus.isHidden = true
            self.vwPlus.isHidden = false
            self.btnPlusMinus.isSelected = true
        } else {
            self.vwMinus.isHidden = false
            self.vwPlus.isHidden = true
            self.btnPlusMinus.isSelected = false
        }
        self.tblTable?.reloadData()
    }
}

//MARK: - UITableViewDelegate,UITableViewDataSource
extension TableVC:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if self.arrTableLeague.count > 0
        {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No teams available"
            noDataLabel.textColor     = UIColor.white
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrTableLeague.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.vwMinus.isHidden == false {
            let cell = self.tblTable.dequeueReusableCell(withIdentifier: "cellPlus") as! cellPlus
            if let obj = self.arrTableLeague[indexPath.row] as? [String:Any] {
                cell.lblScorePTS.text = obj["points"] as? String ?? ""
                if let objTeam = obj["team"] as? [String:Any] {
                    cell.lblTeamName.text = objTeam["name"] as? String ?? ""
                    cell.imgTeam.sd_setImage(with: URL.init(string: "https://spoyer.com/api/team_img/futsal/" + "\((objTeam["id"] as? String ?? ""))" + ".png"), placeholderImage: UIImage.init(named: "ic_club_placeholder"))
                    if indexPath.row == 0 {
                        self.imgTopTeam.sd_setImage(with: URL.init(string: "https://spoyer.com/api/team_img/futsal/" + "\((objTeam["id"] as? String ?? ""))" + ".png"), placeholderImage: UIImage.init(named: "ic_team_placeholder"))
                    }
                }
                
                let win = Int((obj["win"] as? String ?? ""))
                let loss = Int((obj["loss"] as? String ?? ""))
                let draw = Int((obj["draw"] as? String ?? ""))
                
                cell.lblScorePG.text = String.init(format: "%i", ((win ?? 0) + (loss ?? 0) + (draw ?? 0)))
                
                let GoalsFor = Int((obj["goalsfor"] as? String ?? ""))
                let Goalsagainst = Int((obj["goalsagainst"] as? String ?? ""))
                
                cell.lblScoreG.text = String.init(format: "%i", ((GoalsFor ?? 0) + (Goalsagainst ?? 0)))
            }
            return cell
        } else {
            let cell = self.tblTable.dequeueReusableCell(withIdentifier: "cellMinus") as! cellMinus
            if let obj = self.arrTableLeague[indexPath.row] as? [String:Any] {
                cell.lblScorePTS.text = obj["points"] as? String ?? ""
                if let objTeam = obj["team"] as? [String:Any] {
                    cell.imgTeam.sd_setImage(with: URL.init(string: "https://spoyer.com/api/team_img/futsal/" + "\((objTeam["id"] as? String ?? ""))" + ".png"), placeholderImage: UIImage.init(named: "ic_club_placeholder"))
                    if indexPath.row == 0 {
                        self.imgTopTeam.sd_setImage(with: URL.init(string: "https://spoyer.com/api/team_img/futsal/" + "\((objTeam["id"] as? String ?? ""))" + ".png"), placeholderImage: UIImage.init(named: "ic_team_placeholder"))
                    }
                }
                cell.lblScoreW.text = obj["win"] as? String ?? ""
                cell.lblScoreL.text = obj["loss"] as? String ?? ""
                cell.lblScoreD.text = obj["draw"] as? String ?? ""
                cell.lblScoreCH.text = obj["change"] as? String ?? ""
                let GoalsFor = Int((obj["goalsfor"] as? String ?? ""))
                let Goalsagainst = Int((obj["goalsagainst"] as? String ?? ""))
                cell.lblScoreG.text = String.init(format: "%i", ((GoalsFor ?? 0) + (Goalsagainst ?? 0)))
                
                let win = Int((obj["win"] as? String ?? ""))
                let loss = Int((obj["loss"] as? String ?? ""))
                let draw = Int((obj["draw"] as? String ?? ""))

                cell.lblScorePG.text = String.init(format: "%i", ((win ?? 0) + (loss ?? 0) + (draw ?? 0)))
            }
            return cell
        }
    }
}

//MARK: - API Calling Methods
extension TableVC {
    func api_getLeagueTableList() {
        HttpRequestManager.shared.getRequest(
            requestURL:URL_Domain + "task=tabledata&league=\(APP_DELEGATE.Id)",
            param:[:],
            showLoader:true)
        {(error,responseDict) -> Void in
            if error != nil {
                showMessageWithRetry(RetryMessage,3, buttonTapHandler: { _ in self.api_getLeagueTableList()
                })
                return
            } else if let dicData = responseDict, dicData.keys.count > 0 {
                self.arrTableLeague.removeAll()
                if let result = dicData["results"] as? [String:Any] , !result.isEmpty {
                    if let objOverAll = result["overall"] as? [String:Any] {
                        if let arrTblRows = objOverAll["tables"] as? [[String:Any]] {
                            if let obj = arrTblRows[0] as? [String:Any] {
                                if let arrRows = obj["rows"] as? [[String:Any]] {
                                    for i in 0 ..< arrRows.count {
                                        self.arrTableLeague.append(arrRows[i])
                                    }
                                }
                            }
                        }
                    }
                }
                self.tblTable.reloadData()
            }
        }
    }
}
