//
//  ViewController.swift
//  SqureCircle2022-06-11
//
//  Created by 村中令 on 2022/06/11.
//

import UIKit

class ViewController: UIViewController {
    //選択したレイヤーをいれておく
    private var selectLayer:CALayer!

    //最後にタッチされた座標をいれておく
    private var touchLastPoint:CGPoint!

    override func viewDidLoad() {
            super.viewDidLoad()

            let width = self.view.bounds.width
            let height = self.view.bounds.height
            //丸を生成するボタン
            let ovalBtn = UIButton()
            ovalBtn.frame = CGRect(x:0,y:0,width:100,height:50)
            ovalBtn.center = CGPoint(x:width / 3,y:height - 30)
            ovalBtn.addTarget(self, action: #selector(self.ovalBtnTapped(sender:)), for: .touchUpInside)
            ovalBtn.setTitle("丸",for:.normal)
            ovalBtn.backgroundColor = UIColor.tintColor
            self.view.addSubview(ovalBtn)

            //四角を生成するボタン
            let rectBtn = UIButton()
            rectBtn.frame = CGRect(x:0,y:0,width:100,height:50)
            rectBtn.center = CGPoint(x:width * 2 / 3,y:height - 30)
        rectBtn.addTarget(self, action: #selector(self.rectBtnTapped(sender:)), for: .touchUpInside)
            rectBtn.setTitle("四角",for:.normal)
            rectBtn.backgroundColor = UIColor.tintColor
            self.view.addSubview(rectBtn)
        }
    //タッチをした時
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            //すでに選択されているレイヤーがあるかもしれないのでnilにしておく
            selectLayer = nil
            //タッチを取得
            let touch:UITouch = touches.first!
            //タッチした場所にあるレイヤーを取得
            let layer:CALayer = hitLayer(touch: touch)
            //タッチされた座標を取得
            let touchPoint:CGPoint = touch.location(in: self.view)
            //最後にタッチされた場所に座標を入れて置く
            touchLastPoint = touchPoint
            //選択されたレイヤーをselectLayerにいれる
            self.selectLayerFunc(layer:layer)
        }
    func hitLayer(touch:UITouch) -> CALayer{
          var touchPoint:CGPoint = touch.location(in:self.view)
          touchPoint = self.view.layer.convert(touchPoint, to: self.view.layer.superlayer)
          return self.view.layer.hitTest(touchPoint)!
      }

    func selectLayerFunc(layer:CALayer?) {
         if((layer == self.view.layer) || (layer == nil)){
             selectLayer = nil
             return
         }
         selectLayer = layer
     }

    //タッチが動いた時
       override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
           let touch:UITouch = touches.first!
           let touchPoint:CGPoint = touch.location(in:self.view)
           //直前の座標との差を取得
           let touchOffsetPoint:CGPoint = CGPoint(x:touchPoint.x - touchLastPoint.x,
                                                  y:touchPoint.y - touchLastPoint.y)
           touchLastPoint = touchPoint

           if (selectLayer != nil){
               //hitしたレイヤーがあった場合
               let px:CGFloat = selectLayer.position.x
               let py:CGFloat = selectLayer.position.y
               //レイヤーを移動させる
               CATransaction.begin()
               CATransaction.setDisableActions(true)
               selectLayer.position = CGPoint(x:px + touchOffsetPoint.x,y:py + touchOffsetPoint.y)
               selectLayer.borderWidth = 3.0
               selectLayer.borderColor = UIColor.green.cgColor
               CATransaction.commit()
           }
       }

    //タッチを終えた時
       override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
           if(selectLayer != nil){
               selectLayer.borderWidth = 0
           }
       }
       //タッチがキャンセルされた時
       override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
           if(selectLayer != nil){
               selectLayer.borderWidth = 0
           }
       }


    @objc func ovalBtnTapped(sender:UIButton){
        //丸を描く
                let oval = MyShapeLayer()
                oval.frame = CGRect(x:30,y:30,width:80,height:80)
                oval.drawOval(lineWidth:1)
                self.view.layer.addSublayer(oval)

        }
    @objc func rectBtnTapped(sender:UIButton){
        //四角を描く
               let rect = MyShapeLayer()
               rect.frame = CGRect(x:40,y:40,width:50,height:50)
               rect.drawRect(lineWidth:1)
               self.view.layer.addSublayer(rect)
        }
}

