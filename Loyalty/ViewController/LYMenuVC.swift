//
//  LYMenuVC.swift
//  Loyalty
//
//  Created by Krishnamoorthy on 13/07/17.
//  Copyright © 2017 Krishnamoorthy. All rights reserved.
//

import UIKit

class LYMenuVC: UIViewController,UITableViewDataSource,UITableViewDelegate
{

   
    let loginModel = SharedInstance.returnUserLoginDetails()

    @IBOutlet weak var img_ProfileImage: UIImageView!
    @IBOutlet weak var lbl_ProfileName: UILabel!
    
    
    let menuImageArr = ["HomeIcon","Aboutus","EditeProfileIcon","memberShipIcon","logOutIcon"]
    let menuNameArr = ["Home","About Us","Edit Profile","Membership","Logout"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //  tbl_specialTableView.tableFooterView = UIView()

        img_ProfileImage.layer.cornerRadius = 40
        img_ProfileImage.layer.masksToBounds = true
        
        self.lbl_ProfileName.text = self.loginModel.fullname
        self.img_ProfileImage.sd_setImage(with: URL(string:self.loginModel.userImage), placeholderImage: UIImage(named: "loading-1.gif"))
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        if self.loginModel.isChanged {
            self.lbl_ProfileName.text = self.loginModel.fullname
            self.img_ProfileImage.image = self.loginModel.storedImage
        }
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func pressCloseButton(_ sender: Any) {
        let elDrawer: KYDrawerController? = (navigationController?.parent as? KYDrawerController)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "LYHomeVC")
        let navController = UINavigationController(rootViewController: viewController)
        navController.setNavigationBarHidden(true, animated: true)
        elDrawer?.mainViewController = navController
        elDrawer?.setDrawerState(.closed, animated: true)
    }

    // MARK: - Table View Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuNameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? LYMenuVCTableViewCell
        
        cell?.img_MenuImage.image = UIImage(named:menuImageArr[indexPath.row])
        cell?.lbl_MenuName.text   = menuNameArr[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 4) {
            let alertController = UIAlertController(title: "Alert!", message: "Are you sure, you want to logout?", preferredStyle: UIAlertControllerStyle.alert)
            
            let CancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default)
            {
                (result : UIAlertAction) -> Void in
                
            }
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            {
                (result : UIAlertAction) -> Void in
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "LYLoginVC") as! LYLoginVC
                let navigationController = UINavigationController(rootViewController: controller)
                navigationController.isNavigationBarHidden = true
                /*
                 let transition = CATransition()
                 transition.duration = 0.3
                 transition.type = kCATransitionPush
                 transition.subtype = kCATransitionFromLeft
                 view.window!.layer.add(transition, forKey: kCATransition)
                 */
                
                let defaults = UserDefaults.standard
                defaults.removeObject(forKey: "userName")
                defaults.removeObject(forKey: "passWord")
                defaults.synchronize()
                self.present(navigationController, animated: true, completion: nil)
            }
            
            alertController.addAction(CancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            let elDrawer: KYDrawerController? = (navigationController?.parent as? KYDrawerController)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "LYHomeVC") as! LYHomeVC
            viewController.teststring = "\(indexPath.row)"
            
            let navController = UINavigationController(rootViewController: viewController)
            navController.setNavigationBarHidden(true, animated: false)
            elDrawer?.mainViewController = navController
            elDrawer?.setDrawerState(.closed, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let cellDefaultHeight: CGFloat = 40
        let screenDefaultHeight: CGFloat = 568
        let factor: CGFloat = cellDefaultHeight / screenDefaultHeight
        return factor * UIScreen.main.bounds.size.height
    }

}
