//
//  GameViewController.swift
//  BaraBaraGame
//
//  Created by 曽根大輔 on 2018/04/16.
//  Copyright © 2018年 曽根大輔. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet var imgView1: UIImageView! //上の画像
    @IBOutlet var imgView2: UIImageView! //真ん中の画像
    @IBOutlet var imgView3: UIImageView! //下の画像
    
    @IBOutlet var resultLabel: UILabel! //スコアを表示させるラベル
    
    var timer: Timer! //画像を動かすためのタイマー
    var score: Int = 1000 //スコアの値
    let defaults: UserDefaults = UserDefaults.standard //スコアを保存するための変数
    
    let width: CGFloat = UIScreen.main.bounds.size.width //画面幅
    var positionX: [CGFloat] = [0.0, 0.0, 0.0] //画面の位置の配列
    var dx: [CGFloat] = [1.0,0.5, -1.0] //画像の動かす幅の配列
    
    func start(){
        //結果レベルを見えなくする
        resultLabel.isHidden = true
        
        //タイマーを動かす
        timer = Timer.scheduledTimer(timeInterval: 0.0005, target: self, selector: #selector(self.up), userInfo: nil, repeats: true)
        
        timer.fire()
    }
    
    @objc func up(){
        for i in 0..<3 {
            //端に来たら動かす向きを逆にする
            if positionX[i] > width || positionX[i] < 0 {
                dx[i] = dx[i] * (-1)
                
            }
            positionX[i] += dx[i] //画像の位置をdx分ずらす
            
        }
        imgView1.center.x = positionX[0] //上の画像をずらしたに移動させる
        imgView2.center.x = positionX[1] //真ん中の画像をずらした位置に移動させる
    }
    
    //ストップボタンを押したら
    @IBAction func stop(){
        if timer.isValid == true { //もしタイマーが動いていたら
            timer.invalidate() //タイマーを止める
            
        }
        for i in 0..<3 {
            score = score - abs(Int(width/2 - positionX[i]))*2 //スコアの計算をする
        }
        resultLabel.text = "score : " + String(score) //結果ラベルにスコアを表示する
        resultLabel.isHidden = false //結果ラベルを隠さない（現す）
        
        let highScore1: Int = defaults.integer(forKey: "score1")
        let highScore2: Int = defaults.integer(forKey: "score2")
        let highScore3: Int = defaults.integer(forKey: "score3")
        
        if score > highScore1 { //ランキング1位の記録を更新したら
            defaults.set(score, forKey: "score1")
            defaults.set(highScore1, forKey: "score2")
            defaults.set(highScore2, forKey: "score3")
        } else if  score > highScore2 {
            defaults.set(score, forKey: "score2")
            defaults.set(highScore1, forKey: "score3")
        } else if score > highScore3 {
            defaults.set(score, forKey: "score3")
        }
        defaults.synchronize()
        
    }
    
    @IBAction func retry(){
        score = 1000 //スコアの値をリセットする
        positionX = [width/2, width/2, width/2]
        if timer.isValid == false {
            
            self.start() //スタートメソッドを呼び出す
        }
        
    }
    
    @IBAction func toTop(){
        self.dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
