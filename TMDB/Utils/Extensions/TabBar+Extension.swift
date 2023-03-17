//
//  TabBar+Extension.swift
//  TMDB
//
//  Created by acupofstarbugs on 16/03/2023.
//

import Foundation
import UIKit.UITabBarController

extension UITabBarController {
    func setTabbar(hidden: Bool, animate: Bool) {
        let animDuration = animate ? 0.4 : 0.0
        UIView.animate(withDuration: animDuration) { [weak self] in
            if let self {
                var frame = self.tabBar.frame
                frame.origin.y = self.view.frame.height
                if !hidden {
                    frame.origin.y -= frame.height
                }
                else {
                    //
                }
                self.tabBar.frame = frame
            }
        }
    }
}
