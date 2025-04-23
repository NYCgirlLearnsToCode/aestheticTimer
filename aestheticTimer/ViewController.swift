//
//  ViewController.swift
//  aestheticTimer
//
//  Created by Lisa J on 4/22/25.
//

import UIKit

final class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var timerView: CircularTimerView!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTimer()
    }

    // MARK: - Actions
    @IBAction func startTapped(_ sender: UIButton) {
        timerView.start()
    }

    // MARK: - Helpers
    private func configureTimer() {
        timerView.duration = 60 // or use a dynamic value / inject
    }
}
