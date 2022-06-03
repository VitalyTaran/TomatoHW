//
//  ViewController.swift
//  TomatoHW11
//
//  Created by Виталий Таран on 02.06.2022.
//

import UIKit


class ViewController: UIViewController {
    var timer = Timer()
    var durationTimer: Int = 0
    let shapeGreyLayer = CAShapeLayer()
    let shapeProgressLayer = CAShapeLayer()
    var pausedTime: CFTimeInterval?
    let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
    var isTapButton: Bool = false
    var isBreak = false

    var pulseLayer = CAShapeLayer()

    //MARK: - CreateUI
    var timerLable: UILabel = {
        let lable = UILabel()
        var countSecond: Int = 0
        var countMinutes: Int = 0
        lable.text = "0\(countMinutes) : 0\(countSecond)"
        lable.font = UIFont.boldSystemFont(ofSize: 60)
        lable.textColor = .systemPink
        lable.textAlignment = .center
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()

    let circleBar: UIView = {
        let circle = UIView()
        let shapeLayer = CAShapeLayer()
        circle.layer.addSublayer(shapeLayer)
        circle.translatesAutoresizingMaskIntoConstraints = false
        return circle
    }()

    var circleProgressBar: UIView = {
        let circle = UIView()
        let shapeLayer = CAShapeLayer()
        circle.layer.addSublayer(shapeLayer)
        circle.translatesAutoresizingMaskIntoConstraints = false
        return circle
    }()

    var circleGradientProgressBar: UIView = {
        let circle = UIView()
        let shapeLayer = CAShapeLayer()
        circle.layer.addSublayer(shapeLayer)
        circle.translatesAutoresizingMaskIntoConstraints = false
        return circle
    }()

    var startButton: UIButton = {
        let startButton = UIButton(frame: CGRect(x: 280, y: 450, width: -170, height: 50))
        startButton.setTitle("Start", for: .normal)
        startButton.backgroundColor = .systemPink
        startButton.layer.cornerRadius = 25
        startButton.tintColor = .systemPink
        return startButton
    }()

    //MARK: - viewDidLayoutSubviews()
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.drawPulsatingLayer()
        self.createdGreyBar()
        self.createdPinkBar()

    }
    //MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        view.addSubview(startButton)
        startButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        animatePulse()
    }

    //MARK: - CreateTimerAction
    @objc func timerAction() {
        durationTimer = durationTimer - 1
        setTimerLabel()
        workOrBreak()
        isTapButton = true
    }

    //MARK: - ButtonAction
    func workOrBreak() {
        if durationTimer <= 0 && isBreak != true {
            if durationTimer == 0 {
                resetProgressBar()
            }
            durationTimer = 10
            startButton.setTitle("Start", for: .normal)
            shapeProgressLayer.pausedAnimation()
            timer.invalidate()
            timerLable.textColor = .systemPink
            startButton.backgroundColor = .systemPink
            shapeProgressLayer.strokeColor = UIColor.systemPink.cgColor
            animateCircle()
            animatePulse()
            timerLable.text = ("00:10")
            isBreak = true
        }

        if durationTimer <= 0 && isBreak != false {
            if durationTimer == 0 {
                resetProgressBar()
                shapeProgressLayer.strokeColor = UIColor.systemGreen.cgColor
            }
            shapeProgressLayer.strokeColor = UIColor.systemGreen.cgColor
            startButton.setTitle("Start", for: .normal)
            durationTimer = 5
            shapeProgressLayer.pausedAnimation()
            timer.invalidate()
            timerLable.textColor = .systemGreen
            startButton.backgroundColor = .systemGreen
            animateCircle()
            timerLable.text = ("00:05")
            isBreak = false
        }

    }

    
    //MARK: - TapButtonAction
    @objc func didTapStartButton() {
        if isTapButton {
            if shapeProgressLayer.isPaused() {
                shapeProgressLayer.startAnimation()
                startButton.setTitle("Pause", for: .normal)
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            } else {
                shapeProgressLayer.pausedAnimation()
                startButton.setTitle("Start", for: .normal)
                timer.invalidate()
            }
        } else {
            if shapeProgressLayer.isPaused() {
                startButton.setTitle("Start", for: .normal)
            } else {
                startButton.setTitle("Pause", for: .normal)
            }
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        }
    }
}

//MARK: - Constraints
extension ViewController {
    func setConstraints() {

        view.addSubview(circleBar)
        NSLayoutConstraint.activate([
            circleBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circleBar.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            circleBar.heightAnchor.constraint(equalToConstant: 300),
            circleBar.widthAnchor.constraint(equalToConstant: 300)
            ])

        view.addSubview(circleProgressBar)
        view.addSubview(circleGradientProgressBar)
        NSLayoutConstraint.activate([
            circleProgressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circleProgressBar.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            circleProgressBar.heightAnchor.constraint(equalToConstant: 300),
            circleProgressBar.widthAnchor.constraint(equalToConstant: 300),
            circleGradientProgressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circleGradientProgressBar.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            circleGradientProgressBar.heightAnchor.constraint(equalToConstant: 300),
            circleGradientProgressBar.widthAnchor.constraint(equalToConstant: 300)
            ])

        view.addSubview(timerLable)
        NSLayoutConstraint.activate([
            timerLable.topAnchor.constraint(equalTo: view.topAnchor, constant: 350),
            timerLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            timerLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ])
    }

}



//MARK: - CreateTimerFormat
extension ViewController {

     func setTimerLabel() {
        let countMinutes = Int(floor(Double(durationTimer) / 60))
        let countSecond = durationTimer - (countMinutes * 60)
        var minuteString = String(countMinutes)
        var secondString = String(countSecond)

        if (countMinutes < 10) {
            minuteString = "0" + minuteString
        }

        if (countSecond < 10) {
            secondString = "0" + secondString
        }

        timerLable.text = minuteString + ":" + secondString
    }
}

extension CALayer {
    func pausedAnimation() {
        if isPaused() == false {
            let pause = convertTime(CACurrentMediaTime(), from: nil)
            speed = 0.0
            timeOffset = pause
        }
    }

    func startAnimation() {
        if isPaused() {
            let pause = timeOffset
            speed = 1.0
            timeOffset = 0.0
            beginTime = 0.0
            let timeSincePause = convertTime(CACurrentMediaTime(), from: nil) - pause
            beginTime = timeSincePause
        }
    }

    func isPaused() -> Bool {
        return speed == 0
    }
}

//MARK: - CreatedLayers
extension ViewController {
    func createdGreyBar() {
        let centre = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        let circlePath = UIBezierPath(arcCenter: centre, radius: 138, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        shapeGreyLayer.path = circlePath.cgPath
        shapeGreyLayer.lineWidth = 13
        shapeGreyLayer.fillColor = UIColor.clear.cgColor
        shapeGreyLayer.strokeEnd = 1
        shapeGreyLayer.lineCap = CAShapeLayerLineCap.round
        shapeGreyLayer.strokeColor = UIColor.systemGray3.cgColor
        view.layer.addSublayer(shapeGreyLayer)
    }

    func createdPinkBar() {
        let centre = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        let circlePath = UIBezierPath(arcCenter: centre, radius: 138, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        shapeProgressLayer.path = circlePath.cgPath
        shapeProgressLayer.lineWidth = 13
        shapeProgressLayer.fillColor = nil
        shapeProgressLayer.strokeEnd = 1
        shapeProgressLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(shapeProgressLayer)
    }
    func drawPulsatingLayer() {
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 150, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        pulseLayer.path = circularPath.cgPath
        pulseLayer.lineWidth = 2.0
        pulseLayer.fillColor = UIColor.clear.cgColor
        pulseLayer.strokeColor = #colorLiteral(red: 1, green: 0.6722753644, blue: 0.7758004069, alpha: 0.6973820364).cgColor
        pulseLayer.lineCap = .round
        pulseLayer.position = view.center
        view.layer.addSublayer(pulseLayer)
    }

    //MARK: - CreatedAnimation
    
    func animateCircle() {
        if pausedTime != nil {
            shapeProgressLayer.speed = 1.0
            shapeProgressLayer.timeOffset = 0.0
            shapeProgressLayer.beginTime = 0.0
        } else {
            basicAnimation.toValue = 0
            basicAnimation.duration = CFTimeInterval(durationTimer)
            basicAnimation.fillMode = CAMediaTimingFillMode.forwards
            basicAnimation.isRemovedOnCompletion = false
            shapeProgressLayer.add(basicAnimation, forKey: "basicAnimation")
            view.layer.addSublayer(shapeProgressLayer)
        }
    }

    func animatePulse() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 2.0
        animation.fromValue = 1.0
        animation.toValue = 1.2
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.repeatCount = Float.infinity
        animation.autoreverses = true
        animation.isRemovedOnCompletion = true
        pulseLayer.add(animation, forKey: "scale")
    }

    //MARK: - Reset Progress
    @objc func resetProgressBar() {
        shapeProgressLayer.strokeEnd = 0
        shapeProgressLayer.strokeColor = nil
        shapeProgressLayer.removeAllAnimations()
    }
}

