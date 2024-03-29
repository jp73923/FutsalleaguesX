//
//  ViewController.swift
//  FutsalleaguesX
//
//  Created by macOS on 02/02/23.
//

import UIKit

class ViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var btnMatch: UIButton!
    @IBOutlet weak var btnTable: UIButton!
    @IBOutlet weak var btnRule: UIButton!
    @IBOutlet weak var btnOption: UIButton!
    @IBOutlet weak var btnIntrest: UIButton!
    
    @IBOutlet weak var vwMatch: UIView!
    @IBOutlet weak var vwTable: UIView!
    @IBOutlet weak var vwRule: UIView!
    @IBOutlet weak var vwOption: UIView!
    @IBOutlet weak var vwIntrest: UIView!

    @IBOutlet weak var heightDropDown: NSLayoutConstraint!
    @IBOutlet weak var lblSelectedLeague: UILabel!

    //MARK: - Global Variables
    var arrTableLeague = [[String:Any]]()
    var tblVC:TableVC?
    var matchVC:MatchesVC?
    var intrestVC:IntrestVC?

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resetAllButtons()
        self.btnMatch.isSelected = true
        self.vwMatch.isHidden = false
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromTable" {
            if let vc = segue.destination as? TableVC {
                self.tblVC = vc
            }
        }
        if segue.identifier == "fromMatches" {
            if let vc = segue.destination as? MatchesVC {
                self.matchVC = vc
            }
        }
        if segue.identifier == "fromIntrest" {
            if let vc = segue.destination as? IntrestVC {
                self.intrestVC = vc
            }
        }
    }
        
    //MARK: - Custom Functions
    func resetAllButtons() {
        self.btnMatch.isSelected = false
        self.btnTable.isSelected = false
        self.btnRule.isSelected = false
        self.btnOption.isSelected = false
        self.btnIntrest.isSelected = false
        
        self.vwMatch.isHidden = true
        self.vwTable.isHidden = true
        self.vwRule.isHidden = true
        self.vwOption.isHidden = true
        self.vwIntrest.isHidden = true
    }
    
    //MARK: - IBActions
    @IBAction func btnDropDownAction(_ sender: Any) {
        if heightDropDown.constant == 0.0 {
            heightDropDown.constant = 315.0
        } else {
            heightDropDown.constant = 0.0
        }
    }
    @IBAction func btnDropDownSelectionAction(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            self.lblSelectedLeague.text = "Czech 1 Liga"
            APP_DELEGATE.Id = "1526"
            break
        case 2:
            self.lblSelectedLeague.text = "Italy Serie A"
            APP_DELEGATE.Id = "2955"
            break
        case 3:
            self.lblSelectedLeague.text = "Japan F League"
            APP_DELEGATE.Id = "1944"
            break
        case 4:
            self.lblSelectedLeague.text = "Poland SuperLiga"
            APP_DELEGATE.Id = "1205"
            break
        case 5:
            self.lblSelectedLeague.text = "Portugal Premier League"
            APP_DELEGATE.Id = "24251"
            break
        case 6:
            self.lblSelectedLeague.text = "Romania Liga"
            APP_DELEGATE.Id = "1422"
            break
        case 7:
            self.lblSelectedLeague.text = "Russia Superleague"
            APP_DELEGATE.Id = "1755"
            break
        case 8:
            self.lblSelectedLeague.text = "Spain Segunda División"
            APP_DELEGATE.Id = "2338"
            break
        default:
            break
        }
        heightDropDown.constant = 0.0
        
        if self.btnTable.isSelected {
            if let vc = self.tblVC {
                vc.api_getLeagueTableList()
            }
        }
        if self.btnMatch.isSelected {
            if let vc = self.matchVC {
                vc.api_getPastMatches()
            }
        }
    }
    @IBAction func btnMatchAction(_ sender: Any) {
        self.resetAllButtons()
        self.btnMatch.isSelected = true
        self.vwMatch.isHidden = false
    }
    @IBAction func btnTableAction(_ sender: Any) {
        self.resetAllButtons()
        self.btnTable.isSelected = true
        self.vwTable.isHidden = false
    }
    @IBAction func btnRulesAction(_ sender: Any) {
        self.resetAllButtons()
        self.btnRule.isSelected = true
        self.vwRule.isHidden = false
    }
    @IBAction func btnOptionAction(_ sender: Any) {
        self.resetAllButtons()
        self.btnOption.isSelected = true
        self.vwOption.isHidden = false
    }
    @IBAction func btnIntrestAction(_ sender: Any) {
        self.resetAllButtons()
        self.btnIntrest.isSelected = true
        self.vwIntrest.isHidden = false
        if self.btnIntrest.isSelected {
            if let vc = self.intrestVC {
                vc.tblIntrest.reloadData()
            }
        }
    }
}
