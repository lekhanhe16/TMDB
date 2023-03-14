//
//  AccountViewController.swift
//  TMDB
//
//  Created by acupofstarbugs on 04/03/2023.
//

import UIKit

class AccountViewController: UIViewController {
    @IBOutlet weak var btnSignIn: UIButton!
    let viewModel =  AccountViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if viewModel.isUserLogin() != nil {
            let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "uservc") as! UserViewController
            tabBarController?.viewControllers?[3] = newViewController
        }
        else {
            
        }
    }
    
    @IBAction func btnSignInClicked(_ sender: UIButton) {
        sender.isHidden = true
        performSegue(withIdentifier: "showloginview", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showloginview" {
            if let vc = segue.destination as? LoginViewController {
                
                vc.dismissClosure = { [weak self](isDismssed: Bool) in
                    if isDismssed {
                        DispatchQueue.main.async {  () in
                            if let weakSelf = self {
                                let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "uservc") as! UserViewController
                                weakSelf.tabBarController?.viewControllers?[3] = newViewController
                            }
                        }
                    }
                    else {
                        if let wself = self {
                            wself.btnSignIn.isHidden = false
                        }
                    }
                }
            }
        }
    }
    deinit {
        print("account view controller deinit")
    }
}
