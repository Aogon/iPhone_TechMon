//
//  BattleViewController.swift
//  TechMon
//
//  Created by Sakai Aoi on 2021/02/09.
//

import UIKit

class BattleViewController: UIViewController {
    
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var playerImageView: UIImageView!
    @IBOutlet var playerHPLabel: UILabel!
    @IBOutlet var playerMPLabel: UILabel!

    @IBOutlet var enemyNameLabel: UILabel!
    @IBOutlet var enemyImageView: UIImageView!
    @IBOutlet var enemyHPLabel: UILabel!
    @IBOutlet var enemyMPLabel: UILabel!
    
    let techMonManger = TechMonManager.shared
    
    var player: Character!
    var enemy: Character!
    
    var playerHP = 100
    var playerMP = 0
    var enemyHP = 200
    var enemyMP = 0
    
    var gameTimer: Timer!
    var isPlayerAttackAvailable: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        player = techMonManger.player
        enemy = techMonManger.enemy
        
        playerNameLabel.text = "勇者"
        playerImageView.image = UIImage(named: "yusya.png")
        playerHPLabel.text = "\(playerHP) / 100"
        playerMPLabel.text = "\(playerMP) / 20"
        
        enemyNameLabel.text = "龍"
        enemyImageView.image = UIImage(named: "monster.png")
        enemyHPLabel.text = "\(enemyHP) / 200"
        enemyMPLabel.text = "\(enemyMP) / 35"
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateGame), userInfo: nil, repeats: true)
        gameTimer.fire()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        techMonManger.playBGM(fileName: "BGM_battle001")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        techMonManger.stopBGM()
    }
    
    @objc func updateGame(){
        playerMP += 1
        if playerMP >= 20 {
            isPlayerAttackAvailable = true
            playerMP = 20
        } else {
            isPlayerAttackAvailable = false
        }
        
        enemyMP += 1
        if enemyMP >= 35 {
            enemyAttack()
            enemyMP = 0
        }
        playerMPLabel.text = "\(playerMP) / 20"
        enemyMPLabel.text = "\(enemyMP) / 35"
        updateUI()
    }
    
    func enemyAttack() {
        techMonManger.damageAnimation(imageView: playerImageView)
        techMonManger.playSE(fileName: "SE_attack")
        playerHP -= 20
        
        playerHPLabel.text = "\(playerHP) / 100"
        if playerHP <= 0 {
            finishBattle(vanishImageView: playerImageView, isPlayerWin: false)
        }
    }
    
    func finishBattle(vanishImageView: UIImageView, isPlayerWin: Bool){
        techMonManger.vanishAnimation(imageView: vanishImageView)
        techMonManger.stopBGM()
        gameTimer.invalidate()
        isPlayerAttackAvailable = false
        
        var finishMessage: String = ""
        if isPlayerWin {
            techMonManger.playSE(fileName: "SE_fanfare")
            finishMessage = "勇者の勝利！！"
        }else{
            techMonManger.playSE(fileName: "SE_gameover")
            finishMessage = "勇者の敗北…"
        }
        
        let alert = UIAlertController(title: "バトル終了", message: finishMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func attackAcction(){
        if isPlayerAttackAvailable {
            techMonManger.damageAnimation(imageView: enemyImageView)
            techMonManger.playSE(fileName: "SE_attack")
            
            enemyHP -= 30
            playerMP = 0
            
            enemyHPLabel.text = "\(enemyHP) / 200"
            playerMPLabel.text = "\(playerMP) / 20"
            
            if enemyHP <= 0 {
                finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
            }
        }
    }
    
    func updateUI(){
        playerHPLabel.text = "\(player.currentHP) / \(player.maxHP)"
        playerMPLabel.text = "\(player.currentMP) / \(player.maxMP)"
        
        enemyHPLabel.text = "\(enemy.currentHP) / \(enemy.maxHP)"
        enemyMPLabel.text = "\(enemy.currentMP) / \(enemy.maxMP)"
    }
    
    func judgeBattle(){
        if player.currentMP <= 0 {
            finishBattle(vanishImageView: playerImageView, isPlayerWin: false)
        } else if enemy.currentHP <= 0 {
            finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
