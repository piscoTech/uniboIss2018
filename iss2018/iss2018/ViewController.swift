//
//  ViewController.swift
//  iss2018
//
//  Created by Marco Boschi on 15/06/2018.
//  Copyright © 2018 Marco Boschi. All rights reserved.
//

import Cocoa
import MBLibrary

class ViewController: NSViewController {
	
	@IBOutlet weak var temperatureField: NSTextField!
	@IBOutlet weak var timeField: NSTextField!
	@IBOutlet weak var colorPicker: NSColorWell!
	
	@IBOutlet weak var lamp: NSView!
	@IBOutlet weak var offLabel: NSTextField!
	@IBOutlet weak var toggleButton: NSButton!
	
	private var isOn = true

	override func viewDidLoad() {
		super.viewDidLoad()

		temperatureField.resignFirstResponder()
		timeField.resignFirstResponder()
		
		lamp.wantsLayer = true
		lamp.layer?.borderColor = NSColor.darkGray.cgColor
		lamp.layer?.borderWidth = 1
		lamp.layer?.masksToBounds = true
		toggleLamp(self)
	}
	
	override func viewDidLayout() {
		super.viewDidLayout()
		
		lamp.layer?.cornerRadius = lamp.frame.width / 2
	}

	@IBAction func sendTemperature(_ sender: AnyObject) {
		guard let temp = (temperatureField.formatter as? NumberFormatter)?.number(from: temperatureField.stringValue) else {
			temperatureField.shake()
			temperatureField.becomeFirstResponder()
			return
		}
		
		print("New temperature: \(temp)")
		temperatureField.resignFirstResponder()
	}

	@IBAction func sendTime(_ sender: AnyObject) {
		print("New time: \(timeField.stringValue)")
		timeField.resignFirstResponder()
	}
	
	@IBAction func updateColor(_ sender: AnyObject) {
		guard isOn else {
			return
		}
		
		lamp.layer?.backgroundColor = colorPicker.color.cgColor
	}
	
	@IBAction func toggleLamp(_ sender: AnyObject) {
		isOn = !isOn
		if isOn {
			setOn()
		} else {
			setOff()
		}
	}
	
	private func setOn() {
		toggleButton.title = "Off"
		lamp.layer?.backgroundColor = colorPicker.color.cgColor
		offLabel.isHidden = true
	}
	
	private func setOff() {
		toggleButton.title = "On"
		lamp.layer?.backgroundColor = NSColor.clear.cgColor
		offLabel.isHidden = false
	}

}

