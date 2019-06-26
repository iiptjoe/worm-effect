//
//  ViewController.swift
//  I Am Poor
//
//  Created by M.Syarif Hidayat on 09/04/19.
//  Copyright © 2019 self. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox


class ViewController: UIViewController,AVAudioPlayerDelegate {
    
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var backgroundFirst: UIImageView!
    @IBOutlet weak var backgroundSecond: UIImageView!
    @IBOutlet weak var wormButton: UIButton!
    @IBOutlet weak var butterflyButton: UIButton!
    @IBOutlet weak var pointsLabel: UILabel!
    
    
    var gameButtons = [UIButton]()
    var gamePoints = 0
    var audioPlayer: AVAudioPlayer!
    
    var worm = [
        UIImage(named: "worm.png")!,
        UIImage(named: "worm2.png")!,
        UIImage(named: "worm3.png")!,
        UIImage(named: "worm4.png")!
    ]
    
    
    enum GameState {
        case gameOver
        case playing
    }
    
    var state = GameState.gameOver
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundSecond.alpha = 0.0
        backgroundSecond.isHidden = true
        // Do any additional setup after loading the view.
        
        
        pointsLabel.isHidden = true
        gameButtons = [wormButton, butterflyButton]
        
        //        func badButtonplay() {
        //        badButton.imageView?.animationImages = worm
        //        badButton.imageView?.animationDuration = 0.3
        //        badButton.imageView?.animationRepeatCount = 10
        //        badButton.imageView?.startAnimating()
        //
        //        }
        
        //        startGameButton.layer.cornerRadius = 0.5 * startGameButton.bounds.size.width
        //        startGameButton.layer.borderColor = UIColor.lightGray.cgColor
        //        startGameButton.layer.borderWidth = 0
        
        setupFreshGameState()
    }
    
    func playSoundBackground(selectedSoundFileName : String) {
        let soundURL = Bundle.main.url(forResource: selectedSoundFileName, withExtension: "wav")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
        }
        catch {
            print(error)
        }
        audioPlayer.numberOfLoops = -1
        audioPlayer.play()
    }
    
    func stopSoundBackground(selectedSoundFileName : String) {
        let soundURL = Bundle.main.url(forResource: selectedSoundFileName, withExtension: "wav")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
        }
        catch {
            print(error)
        }
        audioPlayer.stop()
    }
    
    func startNewGame() {
        gamePoints = 0
        updatePointsLabel(gamePoints)
        pointsLabel.textColor = .white
        pointsLabel.isHidden = false
//        https://www.youtube.com/watch?v=GWlB4dwPDas
        playSoundBackground(selectedSoundFileName: "surprise")
        oneGameRound()
        animateBg()
    }
    
    func animateBg() {
        self.backgroundSecond.alpha = 0.0
        self.backgroundSecond.isHidden = false
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseOut, animations: {
            self.startGameButton.isHidden = true
            self.backgroundFirst.isHidden = true
            self.backgroundSecond.isHidden = false
            self.backgroundSecond.alpha = 1.0
        }, completion: nil)
        
    }
    
    func oneGameRound() {
        updatePointsLabel(gamePoints)
        displayRandomButton()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
            if self.state == GameState.playing {
                if self.currentButton == self.wormButton {
                    self.gameOver()
                   self.stopSoundBackground(selectedSoundFileName: "surprise")
                } else {
                    self.oneGameRound()
                }
            }
        }
    }
    
    
    @IBAction func startPress(_ sender: Any) {
        state = GameState.playing
//        http://soundbible.com/1362-Old-Door-Creaking.html
        playSoundBackground(selectedSoundFileName: "Door")
        startNewGame()
        
    }
    
    @IBAction func goodPreseed(_ sender: Any) {
        gamePoints = gamePoints + 1
        updatePointsLabel(gamePoints)
        wormButton.isHidden = true
        timer?.invalidate()
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        oneGameRound()

    }
    
    @IBAction func badPressed(_ sender: Any) {
        butterflyButton.isHidden = true
        timer?.invalidate()
        gameOver()
        stopSoundBackground(selectedSoundFileName: "surprise")

    }
    
    var timer : Timer?
    var currentButton: UIButton!
    
    func displayRandomButton() {
        for mybutton in gameButtons {
            mybutton.isHidden = true
        }
        let buttonIndex = Int.random(in: 0..<gameButtons.count)
        currentButton = gameButtons[buttonIndex]
        currentButton.center = CGPoint(x: randomXCoordinate(), y: randomYCoordinate())
        currentButton.isHidden = false
        
        if currentButton == wormButton {
            print("bad button")
            wormButton.imageView?.animationImages = worm
            wormButton.imageView?.animationDuration = 1
            wormButton.imageView?.animationRepeatCount = -1 //-1 artinya looping
            wormButton.imageView?.startAnimating()
        }
        
    }
    
    func gameOver() {
        state = GameState.gameOver
        pointsLabel.isHidden = true
        pointsLabel.textColor = .white
        setupFreshGameState()
    }
    
    func setupFreshGameState() {
        startGameButton.isHidden = false
        backgroundSecond.isHidden = true
        backgroundFirst.isHidden = false
        for mybutton in gameButtons {
            mybutton.isHidden = true
        }
        pointsLabel.alpha = 0.5
        currentButton = wormButton
        state = GameState.gameOver
    }
    
    func randCGFloat(_ min: CGFloat, _ max: CGFloat) -> CGFloat {
        return CGFloat.random(in: min..<max)
    }
    
    func randomXCoordinate() -> CGFloat {
        let left = view.safeAreaInsets.left + currentButton.bounds.width
        let right = view.bounds.width - view.safeAreaInsets.right - currentButton.bounds.width
        return randCGFloat(left, right)
    }
    
    func randomYCoordinate() -> CGFloat {
        let top = view.safeAreaInsets.top + currentButton.bounds.height
        let bottom = view.bounds.height - view.safeAreaInsets.bottom - currentButton.bounds.height
        return randCGFloat(top, bottom)
    }
    
    func updatePointsLabel(_ newValue: Int) {
        pointsLabel.text = "\(newValue)"
    }
}
