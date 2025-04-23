//
//  CircularTimerView.swift
//  aestheticTimer
//
//  Created by Lisa J on 4/22/25.
//
import UIKit

final class CircularTimerView: UIView {
    
    // MARK: - Public Properties
    var duration: TimeInterval = 60.0 {
        didSet {
            guard duration > 0 else { duration = 1.0; return }
        }
    }
    
    var isPaused = false {
        didSet {
            if isPaused {
                stop()
            }
        }
    }
    
    // MARK: - Private Properties
    private let shapeLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()
    private let centerCircleLayer = CAShapeLayer()
    private var displayLink: CADisplayLink?
    private var startTime: CFTimeInterval?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.frame = bounds
        backgroundLayer.frame = bounds
        centerCircleLayer.frame = bounds
        configurePaths()
    }
    
    // MARK: - Public API
    func start() {
        shapeLayer.strokeEnd = 0
        startTime = CACurrentMediaTime()
        stop() // Ensure any previous animation is cancelled
        
        displayLink = CADisplayLink(target: self, selector: #selector(updateProgress))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    func stop() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    // MARK: - Private Methods
    private func setupLayers() {
        backgroundLayer.fillColor = UIColor.systemGray4.cgColor
        
        shapeLayer.fillColor = UIColor(red: 134.0/255.0, green: 170.0/255.0, blue: 207.0/255.0, alpha: 1.0).cgColor
        
        centerCircleLayer.fillColor = UIColor.systemBackground.cgColor
        
        
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(shapeLayer)
        layer.addSublayer(centerCircleLayer)
    }
    
    private func configurePaths() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2
        
        let fullCircle = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: true
        )
        backgroundLayer.path = fullCircle.cgPath
        
        // Initially empty pie slice
        shapeLayer.path = UIBezierPath().cgPath
        
        centerCircleLayer.path = UIBezierPath(
            arcCenter: center,
            radius: radius/3,
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: true
        ).cgPath
    }
    
    
    @objc private func updateProgress() {
        guard let start = startTime else { return }
        let elapsed = CACurrentMediaTime() - start
        let progress = min(elapsed / duration, 1)
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + 2 * .pi * CGFloat(progress)
        
        let piePath = UIBezierPath()
        piePath.move(to: center)
        piePath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        piePath.close()
        
        shapeLayer.path = piePath.cgPath
        
        if progress >= 1 {
            stop()
        }
    }
    
}
