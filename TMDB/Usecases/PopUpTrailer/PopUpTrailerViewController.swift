//
//  PopUpTrailerViewController.swift
//  TMDB
//
//  Created by acupofstarbugs on 27/02/2023.
//

import UIKit
import youtube_ios_player_helper

class PopUpTrailerViewController: UIViewController, YTPlayerViewDelegate {
    
    @IBOutlet weak var playerView: YTPlayerView!
    var video_id: String = ""
    init?(coder: NSCoder, key: String) {
        super.init(coder: coder)
        self.video_id = key
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.delegate = self
        playerView.load(withVideoId: video_id)
    }
    
    deinit {
        print("ppopup view controller deinit")
    }
}
