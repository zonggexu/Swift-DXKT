//
//  XDanMuView.swift
//  xdanmu
//  弹幕视图
//  Created by wangyu on 2023/7/21.
//

import Foundation
import UIKit

class XDanMu {
    var row: Int = 0
    var label: UIButton = UIButton(type: .custom)
    var speed: CGFloat = 0
    var isMe: Bool = false
}

class XDanMuView: UIView {
    var displayLink: CADisplayLink?
    
    var lineHeight: CGFloat = 26
    var gap: CGFloat = 20
    var minSpeed: CGFloat = 1
    var maxSpeed: CGFloat = 2
    var isPause: Bool = false
    
    var danmus: [XDanMu] = []
    var danmuQueue: [(String, Bool)] = []
    var timer: Timer?
    
    func start() {
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink?.add(to: RunLoop.current, forMode: .common)
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(handleDanMuQueue), userInfo: nil, repeats: true)
    }
    
    func stop() {
        displayLink?.invalidate()
        displayLink = nil
        timer?.invalidate()
        timer = nil
        danmuQueue = []
        danmus = []
        self.Jh_removeAllSubviews()
    }
    
    @objc func handleDanMuQueue() {
        if danmuQueue.isEmpty {
            return
        }
        let danmu = danmuQueue.removeFirst()
        addDanMu(text: danmu.0, isMe: danmu.1)
    }
    
    @objc func addDanMu(text: String, isMe: Bool) {
        let danmu = XDanMu()
        danmu.label.frame.origin.x = self.frame.size.width
//        danmu.label.titleLabel?.text = text
//        danmu.label.sizeToFit()
//        danmu.label.titleLabel?.textColor = JhRandomColor()
        
        danmu.label.setTitle("  " + text + "  ", for: .normal)
        danmu.label.sizeToFit()
        danmu.label.setTitleColor(.black, for: .normal)
        danmu.label.titleLabel?.font = .systemFont(ofSize: 14)
        danmu.label.backgroundColor = UIColorFromRGBAndAlpha("F9F9F9", 0.9)
        danmu.label.layer.borderWidth = 1
//        danmu.label.layer.borderColor(.red)
        danmu.label.layer.cornerRadius = danmu.label.Jh_height / 2
        danmu.label.layer.masksToBounds = true
        
//        if isMe {
//            danmu.label.layer.borderWidth = 1
//        }
        
        var linelasts: [XDanMu?] = []
        let rows: Int = Int(self.frame.size.height / lineHeight)
        for _ in 0..<rows {
            linelasts.append(nil)
        }
        
        for d in danmus {
            if d.row >= linelasts.count {
                break
            }
            if linelasts[d.row] != nil {
                let endx = danmu.label.frame.origin.x
                let targetx = linelasts[d.row]!.label.frame.origin.x
                if endx > targetx {
                    linelasts[d.row] = d
                }
            } else {
                linelasts[d.row] = d
            }
        }
        
        var isMatch = false
        for index in 0..<linelasts.count {
            if let d = linelasts[index] {
                let endx = d.label.frame.origin.x + d.label.frame.size.width + gap
                if endx < self.frame.size.width {
                    danmu.row = index
                    var ms = self.frame.size.width / endx * d.speed
                    ms = CGFloat.minimum(ms, maxSpeed)
                    danmu.speed = CGFloat.random(in: minSpeed...ms)
                    isMatch = true
                    break
                }
            } else {
                danmu.row = index
                danmu.speed = CGFloat.random(in: minSpeed...maxSpeed)
                isMatch = true
                break
            }
        }
        
        if isMatch == false {
            danmuQueue.append((text, isMe))
            return
        }
        
        danmu.label.frame.origin.y = lineHeight * CGFloat(danmu.row)
        if CGFloat(danmu.row) > 0 {
            danmu.label.frame.origin.y = danmu.label.frame.origin.y + 10 * CGFloat(danmu.row)
        }
        
        self.addSubview(danmu.label)
        self.danmus.append(danmu)
    }
    
    @objc func update(_ displayLink: CADisplayLink) {
        if isPause == true {
            return
        }
        // 在每一帧更新时移动视图
        for index in 0..<danmus.count {
            let danmu = danmus[index]
            danmu.label.frame.origin.x -= danmu.speed
            if danmu.label.frame.origin.x < -danmu.label.frame.size.width {
                danmu.label.removeFromSuperview()
                danmus.remove(at: index)
                break
            }
        }
    }
}
