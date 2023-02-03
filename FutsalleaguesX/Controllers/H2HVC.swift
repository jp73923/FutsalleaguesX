//
//  H2HVC.swift
//  FutsalleaguesX
//
//  Created by macOS on 03/02/23.
//

import UIKit
class cellRecentMatch:UITableViewCell {
    //MARK: - IBOutlets
    @IBOutlet weak var lblScore1: UILabel!
    @IBOutlet weak var lblScore2: UILabel!
    @IBOutlet weak var lblTeam1: UILabel!
    @IBOutlet weak var lblTeam2: UILabel!
    @IBOutlet weak var imgTeam1: UIImageView!
    @IBOutlet weak var imgTeam2: UIImageView!
}
class H2HVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblMatchDateTime: UILabel!
    @IBOutlet weak var lblMatchTime: UILabel!
    @IBOutlet weak var lblTeam1: UILabel!
    @IBOutlet weak var lblTeam2: UILabel!
    @IBOutlet weak var imgTeam1: UIImageView!
    @IBOutlet weak var imgTeam2: UIImageView!
    @IBOutlet weak var tblH2h: UITableView!

    //MARK: - Global Variables
    var objMatch = [String:Any]()
    var arrh2h = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let objMatch = objMatch as? [String:Any] {
            if let homeTeam = objMatch["home"] as? [String:Any] {
                self.lblTeam1.text = homeTeam["name"] as? String ?? ""
                self.imgTeam1.sd_setImage(with: URL.init(string: "https://spoyer.com/api/team_img/futsal/" + "\(homeTeam["id"] as? String ?? "")" + ".png"), placeholderImage: UIImage.init(named: "ic_team_1_placeholder"))
            }
            if let awayTeam = objMatch["away"] as? [String:Any] {
                self.lblTeam2.text = awayTeam["name"] as? String ?? ""
                self.imgTeam2.sd_setImage(with: URL.init(string: "https://spoyer.com/api/team_img/futsal/" + "\(awayTeam["id"] as? String ?? "")" + ".png"), placeholderImage: UIImage.init(named: "ic_team_2_placeholder"))
            }
            self.lblScore.text = objMatch["score"] as? String ?? ""
            if let startTimestamp = Int(objMatch["time"] as? String ?? "") {
                let formaor = DateFormatter()
                formaor.dateFormat = "dd.MM.yyyy"
                self.lblMatchDateTime.text = formaor.string(from: NSDate(timeIntervalSince1970: TimeInterval(truncating: NSNumber(value: startTimestamp))) as Date)
                formaor.dateFormat = "hh:mm"
                self.lblMatchTime.text = formaor.string(from: NSDate(timeIntervalSince1970: TimeInterval(truncating: NSNumber(value: startTimestamp))) as Date)
            }
        }
        if let gameId = objMatch["game_id"] as? String {
            self.api_getH2hMatches(gameId: gameId)
        }
    }
    
    //MARK: - IBActions
    @IBAction func btnBackAction(_ sender: UIButton) {
        APP_DELEGATE.appNavigation?.popViewController(animated: true)
    }
}

//MARK: - UITableViewDelegate,UITableViewDataSource
extension H2HVC:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if self.arrh2h.count > 0
        {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No recent mathces available"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrh2h.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblH2h.dequeueReusableCell(withIdentifier: "cellRecentMatch") as! cellRecentMatch
        cell.lblScore1.textColor = UIColor.white
        if let dict = self.arrh2h[indexPath.row] as? [String:Any] {
            if let dictHome = dict["home"] as? [String:Any] {
                if let img1 = dictHome["id"] as? String {
                    cell.imgTeam1.sd_setImage(with: NSURL.init(string: String.init(format: "https://spoyer.com/api/team_img/futsal/%@.png", img1)) as URL?, placeholderImage: UIImage.init(named: "ic_team_1_placeholder"))
                }
            }
            if let dictaway = dict["away"] as? [String:Any] {
                if let img1 = dictaway["id"] as? String {
                    cell.imgTeam2.sd_setImage(with: NSURL.init(string: String.init(format: "https://spoyer.com/api/team_img/futsal/%@.png", img1)) as URL?, placeholderImage: UIImage.init(named: "ic_team_2_placeholder"))
                }
            }
            let Score1 = Int((dict["ss"] as? String ?? "").components(separatedBy: "-")[0]) ?? 0
            let Score2 = Int((dict["ss"] as? String ?? "").components(separatedBy: "-")[1]) ?? 0
            cell.lblScore1.text = ((dict["ss"] as? String ?? "").components(separatedBy: "-")[0])
            cell.lblScore2.text = ((dict["ss"] as? String ?? "").components(separatedBy: "-")[1])
            if Score2 > Score1 {
                cell.lblScore1.textColor = UIColor.red
                cell.lblScore2.textColor = UIColor.green
            }
            if Score2 < Score1 {
                cell.lblScore1.textColor = UIColor.green
                cell.lblScore2.textColor = UIColor.red
            }
            if Score2 == Score1 {
                cell.lblScore1.textColor = UIColor.white
                cell.lblScore2.textColor = UIColor.white
            }
        }
        return cell
    }
}

//MARK: - API Calling Methods
extension H2HVC {
    func api_getH2hMatches(gameId:String) {
        showLoaderHUD()
        let urlString = "https://spoyer.com/api/en/get.php?login=ayna&token=12784-OhJLY5mb3BSOx0O&task=h2h&game_id=" + gameId
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with:request) { (data, response, error) in
            DispatchQueue.main.async {
                hideLoaderHUD()
            }
            if error != nil {
                print(error ?? "")
            } else {
                do {
                    let parsedDictionaryArray = try JSONSerialization.jsonObject(with: data!) as! [String:AnyObject]
                    DispatchQueue.main.async {
                        if let dictData = parsedDictionaryArray as? [String:Any] {
                            if let results = dictData["results"] as? [String:Any] {
                                if let h2h = results["h2h"] as? [[String:Any]] {
                                    self.arrh2h = h2h
                                }
                                self.tblH2h.reloadData()
                            }
                        }
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }.resume()
    }
}
