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
}
class IntrestVC: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var tblIntrest: UITableView!
    
    //MARK: - Global Variables
    var isPast = false

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - IBActions
    @IBAction func btnIntrestAction(_ sender: UIButton) {
        self.tblIntrest.reloadData()
    }
}

//MARK: - UITableViewDelegate,UITableViewDataSource
extension IntrestVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblIntrest.dequeueReusableCell(withIdentifier: "cellIntrestMatch") as! cellIntrestMatch
        cell.lblScore.isHidden = self.isPast ? false : true
        cell.imgVS.isHidden = self.isPast ? true : false
        cell.btnIntrest.tag = indexPath.row
        cell.btnIntrest.addTarget(self, action: #selector(self.btnIntrestAction(_:)), for: UIControl.Event.touchUpInside)
        cell.btnIntrest.isSelected = true
        return cell
    }
}
