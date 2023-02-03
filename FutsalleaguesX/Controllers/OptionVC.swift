//
//  OptionVC.swift
//  FutsalleaguesX
//
//  Created by macOS on 02/02/23.
//

import UIKit

class OptionVC: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var btnOnSound: UIButton!
    @IBOutlet weak var btnOffSound: UIButton!
    @IBOutlet weak var btnOnCalendar: UIButton!
    @IBOutlet weak var btnOffCalendar: UIButton!

    @IBOutlet weak var heightDropDown: NSLayoutConstraint!
    @IBOutlet weak var btnLeague: UIButton!
    @IBOutlet weak var vwPopup: UIView!

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - IBActions
    @IBAction func btnDropDownAction(_ sender: Any) {
        if heightDropDown.constant == 0.0 {
            heightDropDown.constant = 220.0
        } else {
            heightDropDown.constant = 0.0
        }
    }
    @IBAction func btnOnSound(_ sender: Any) {
        self.btnOnSound.isSelected = true
        self.btnOffSound.isSelected = false
    }
    @IBAction func btnOffSound(_ sender: Any) {
        self.btnOnSound.isSelected = false
        self.btnOffSound.isSelected = true
    }
    @IBAction func btnOnCalendar(_ sender: Any) {
        self.btnOnCalendar.isSelected = true
        self.btnOffCalendar.isSelected = false
    }
    @IBAction func btnOffCalendar(_ sender: Any) {
        self.btnOnCalendar.isSelected = false
        self.btnOffCalendar.isSelected = true
    }
    @IBAction func btnClearAction(_ sender: Any) {
        self.vwPopup.isHidden = false
    }
    @IBAction func btnYesAction(_ sender: Any) {
        if let arr = UserDefaultManager.getCustomArrayFromUserDefaults(key: UD_Favourite) as? NSMutableArray, arr.count > 0 {
            arr.removeAllObjects()
            UserDefaultManager.setCustomArrayToUserDefaults(array: arr, key: UD_Favourite)
        }
        self.vwPopup.isHidden = true
    }
    @IBAction func btnNoAction(_ sender: Any) {
        self.vwPopup.isHidden = true
    }
    @IBAction func btnDropDownSelectionAction(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            self.btnLeague.setTitle("Czech 1 Liga", for: UIControl.State.normal)
            APP_DELEGATE.Id = "1526"
            break
        case 2:
            self.btnLeague.setTitle("Italy Serie A", for: UIControl.State.normal)
            APP_DELEGATE.Id = "2955"
            break
        case 3:
            self.btnLeague.setTitle("Japan F League", for: UIControl.State.normal)
            APP_DELEGATE.Id = "1944"
            break
        case 4:
            self.btnLeague.setTitle("Poland SuperLiga", for: UIControl.State.normal)
            APP_DELEGATE.Id = "1205"
            break
        case 5:
            self.btnLeague.setTitle("Portugal Premier League", for: UIControl.State.normal)
            APP_DELEGATE.Id = "24251"
            break
        case 6:
            self.btnLeague.setTitle("Romania Liga", for: UIControl.State.normal)
            APP_DELEGATE.Id = "1422"
            break
        case 7:
            self.btnLeague.setTitle("Russia Superleague", for: UIControl.State.normal)
            APP_DELEGATE.Id = "1755"
            break
        case 8:
            self.btnLeague.setTitle("Spain Segunda División", for: UIControl.State.normal)
            APP_DELEGATE.Id = "2338"
            break
        default:
            break
        }
        heightDropDown.constant = 0.0
    }
}
