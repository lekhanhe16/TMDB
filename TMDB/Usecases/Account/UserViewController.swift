//
//  UserViewController.swift
//  TMDB
//
//  Created by acupofstarbugs on 04/03/2023.
//

import UIKit

class UserViewController: UIViewController {
    var usecases = [[UserUsecase.FAVORITE, .WATCH_LIST],
                    [.RECOMMEND],
                    [.CREATED_LISTs]]
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    deinit {
        print("user view controller deinit")
    }
}

extension UserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usecases[section].count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return usecases.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "user_usecase", for: indexPath)
        let usecase = usecases[indexPath.section][indexPath.row].getUsecase()
            var content = cell.defaultContentConfiguration()
            content.text = usecase
        content.textProperties.color = .blue
        cell.contentConfiguration = content
        return cell
    }
    
}

extension UserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == usecases.count - 1 {
            return nil
        }
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "user_usecase", for: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

enum UserUsecase {
    case FAVORITE, WATCH_LIST, RECOMMEND, CREATED_LISTs
    func getUsecase() -> String{
        switch self {
        case .FAVORITE: return "Favorite"
        case .WATCH_LIST: return "Watch list"
        case .RECOMMEND: return "Recommendations"
        default:
            return "Created lists"
        }
    }
}
