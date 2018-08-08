//
//  MyWindowController.swift
//  DiceRolls
//
//  Created by Justin Reusch on 7/2/18.
//  Copyright © 2018 Justin Reusch. All rights reserved.
//

import Cocoa

class MyWindowController: NSWindowController {
		
	
	override func windowDidLoad() {
		super.windowDidLoad()
		self.setTimes.stringValue = String(100)
	}
	
	var viewController: ViewController {
		get {
			return self.window!.contentViewController! as! ViewController
		}
	}
	
	@IBOutlet var setTimes: NSTextField!
	
}
