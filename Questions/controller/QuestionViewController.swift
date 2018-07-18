//
//  QuestionViewController.swift
//  Questions
//
//  Created by RONAK GARG on 18/07/18.
//  Copyright © 2018 Coviam. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MediaPlayer
import MobileCoreServices

class QuestionViewController: UIViewController,AVPlayerViewControllerDelegate {
    
    var question : Question?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setup()
    }
    @IBOutlet weak var optionA: UILabel!
    @IBOutlet weak var optionB: UILabel!
    @IBOutlet weak var optionC: UILabel!
    @IBOutlet weak var optionD: UILabel!
    
    @IBOutlet weak var correctAnswer: UILabel!
    
    @IBOutlet weak var A: UILabel!
    @IBOutlet weak var B: UILabel!
    @IBOutlet weak var C: UILabel!
    @IBOutlet weak var D: UILabel!
    
    @IBOutlet weak var viewVideoHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewVideo: UIView!
    func setup(){
       
        title = question?.difficulty
        optionA.text = question?.optionOne
        optionB.text = question?.optionTwo
        optionC.text = question?.optionThree
        optionD.text = question?.optionFour
        
        if question?.answer == "A" {
            A.backgroundColor = UIColor.green
            optionA.backgroundColor = UIColor.green
            correctAnswer.text = ""
        }
        else if question?.answer == "B"
        {
            B.backgroundColor = UIColor.green
            optionB.backgroundColor = UIColor.green
            correctAnswer.text = ""
        }
        else if question?.answer == "C"
        {
            C.backgroundColor = UIColor.green
            optionC.backgroundColor = UIColor.green
            correctAnswer.text = ""
        }
        else if question?.answer == "D"
        {
            D.backgroundColor = UIColor.green
            optionD.backgroundColor = UIColor.green
            correctAnswer.text = ""
        }
        else{
            correctAnswer.text = "Correct answer is "+(question?.answer)!
        }
        if question?.questionType == "video"{
            self.view.addSubview(viewVideo)

            videoPlay()
        }
        else if question?.questionType == "image"{
             self.view.addSubview(viewVideo)
            loadImage()
        }
        else if question?.questionType == "audio"{
             self.view.addSubview(viewVideo)
            videoPlay()
        }
        else{
            viewVideoHeight.constant = 0
        }
    }
    
    func videoPlay()
    {
        let player = AVPlayer(url: URL(string: (question?.questionUrl)!)!)
        let controller = AVPlayerViewController()
        controller.player = player
        addChildViewController(controller)
        self.viewVideo.addSubview(controller.view)
        controller.view.frame = self.viewVideo.frame
       controller.showsPlaybackControls = true
        controller.player = player
        player.play()
        
    }
    func loadImage(){
        let url:URL = URL(string: (question?.questionUrl)!)!
        let data:Data = try! Data(contentsOf: url)
        let imgView = UIImageView.init(image: UIImage(data: data))
        self.viewVideo.addSubview(imgView)
        imgView.frame = self.viewVideo.frame
        imgView.contentMode = .scaleAspectFit
    }
}
