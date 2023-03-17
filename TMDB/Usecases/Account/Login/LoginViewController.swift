//
//  LoginViewController.swift
//  TMDB
//
//  Created by acupofstarbugs on 04/03/2023.
//

import UIKit
import GradientCircularProgress

class LoginViewController: UIViewController {
    @IBOutlet weak var loadingIndicator: UIView!
    @IBOutlet weak var btnSignIn: UIButton!
    let progress = GradientCircularProgress()
    var progressView: UIView?
    var dismissClosure: ((Bool) -> Void)!
    let viewModel = LoginViewModel()
    var isLoggedInSuccess = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        txtFieldUsername.text = UserDefaults.standard.string(forKey: "username") ?? ""
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismissClosure(isLoggedInSuccess)
    }
    func showLoadingIndicator() {
        loadingIndicator.isHidden = false
        
        progressView = progress.show(frame: CGRect(x: 0, y: 0, width: 50, height: 50), message: "", style: BlueIndicatorStyle())
        loadingIndicator.addSubview(progressView!)
    }
    @IBOutlet weak var txtFieldPwd: UITextField!
    @IBOutlet weak var txtFieldUsername: UITextField!
    
    @IBAction func btnSignInClicked(_ sender: UIButton) {
        if let username = txtFieldUsername.text, let pass = txtFieldPwd.text {
            
            if !username.isEmpty && !pass.isEmpty {
                sender.isHidden = true
                showLoadingIndicator()
                viewModel.login(username: username, pass: pass) { isSuccess in
                    DispatchQueue.main.async { [weak self] () in
                        self?.progress.dismiss(progress: (self?.progressView)!)
                        self?.isLoggedInSuccess = true
                        print("login \(isSuccess)")
                        if isSuccess {
                            self?.dismiss(animated: true)
                        }
                        else {
                            let alert = UIAlertController(title: "Login failed", message: "Invalid username or password! Please try again.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                            sender.isHidden = false
                            self?.loadingIndicator.isHidden = true
                            self?.present(alert, animated: true)
                        }
                    }
                }
            }
        }
        
    }
    deinit {
        print("login view controller deinit")
    }
}
