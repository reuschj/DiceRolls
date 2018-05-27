//
//  ViewController.swift
//  DiceRolls
//
//  Created by Justin Reusch on 3/27/18.
//  Copyright © 2018 Justin Reusch. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
	
	var people: [Person]?
	var dice: [Die]?
	var rollResults: MultiRollOutput?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		let (people, dice) = makePeopleAndDice()
		(self.people, self.dice) = (people, dice)
		self.rollResults = performRolls(dice: self.dice!)
		
		resultsTable.dataSource = self
		resultsTable.delegate = self
	}

	override var representedObject: Any? {
		didSet {
			// Update the view, if already loaded.
		}
	}
	
	func makePeopleAndDice() -> ([Person], [Die]) {
		// Make a few people
		var people = [Person]()
		let Katherine = Person(name: Name(first: "Katherine"))
		let Zack = Person(name: Name(first: "Zack"))
		let Justin = Person(name: Name(first: "Justin", middle: "Alexander", last: "Reusch"), gender: .male)
		let Hang = Person(name: Name(first: "Hang", last: "Reusch"), gender: .female)
		people.append(Katherine)
		people.append(Zack)
		people.append(Justin)
		people.append(Hang)
		
		// Make the dice
		var dice = [Die]()
		dice.append(Die(sides: [3,3,3,3,3,6], owner: Katherine))
		dice.append(Die(sides: [2,2,2,5,5,5], owner: Zack))
		dice.append(Die(sides: [3,3,3,3,3,6], owner: Justin))
		dice.append(Die(sides: [2,2,2,5,5,5], owner: Hang))
		dice.append(Die(sides: [1,2,3,4,5,6], owner: Justin))
		dice.append(Die(sides: [1,2,3,4,5,6], owner: Hang))
		
		return (people, dice)
	}
	
	func performRolls (dice: [Die]) -> MultiRollOutput {
		
		var numTimesToRoll: UInt = 100
		let currentInput = setTimes.stringValue
		let currentInputInt: Int = Int(setTimes.intValue)
		let curentInputUInt: UInt = UInt(abs(Int32(currentInputInt)))
		let currentInputIsValid = !Float(curentInputUInt).isNaN && curentInputUInt > 0
		if currentInput != "" && currentInputIsValid {
			numTimesToRoll = curentInputUInt
		}
		let result = rollXTimes(timesToRoll: numTimesToRoll, listOfDiceToRoll: dice)
		setTimes.stringValue = String(numTimesToRoll)
		return result
	}
  
//  The text input to set number of times to roll
	@IBOutlet var setTimes: NSTextField!
  
//  A simple text field for text-only output
  @IBOutlet var outputArea: NSTextFieldCell!
	
//  An NSTableView for roll results
  @IBOutlet weak var resultsTable: NSTableView!
  
//  A first test that ouputs to the simple text feild
	@IBAction func testButton(_ sender: NSButton) {
		
		self.rollResults = performRolls(dice: self.dice!)
		resultsTable.reloadData()
		print(self.rollResults!.reportString)
	}
	
}

extension ViewController: NSTableViewDataSource {
	func numberOfRows(in tableView: NSTableView) -> Int {
		return rollResults?.results.count ?? 0
  }
}

extension ViewController: NSTableViewDelegate {
  fileprivate enum CellIdentifiers {
    static let DieNameCell = "DieNameCellID"
    static let ScoreCell = "ScoreCellID"
    static let WinsCell = "WinsCellID"
    static let TiesCell = "TiesCellID"
    static let LossesCell = "LossesCellID"
		static let OtherCell = "OtherCellID"
  }
  
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

		var cellText: String = ""
		var cellIdentifier: String = ""
		
		guard let result = rollResults?.results[row] else {
			return nil
		}
		
		let dieColumn = tableView.tableColumns[0]
		let scoreColumn = tableView.tableColumns[1]
		let winsColumn = tableView.tableColumns[2]
		let tiesColumn = tableView.tableColumns[3]
		let lossesColumn = tableView.tableColumns[4]
		let otherColumn = tableView.tableColumns[5]
		
		func generateCellText (_ result: Int, _ percent: Double) -> String {
			return "\(String(result))\t(\(percentageString(input: percent)))"
		}
		
		switch tableColumn {
			case dieColumn:
				cellText = result.die.name
				cellIdentifier = CellIdentifiers.DieNameCell
			case scoreColumn:
				cellText = String(result.totalScore)
				cellIdentifier = CellIdentifiers.ScoreCell
			case winsColumn:
				cellText = generateCellText(result.win, result.winPercent)
				cellIdentifier = CellIdentifiers.WinsCell
			case tiesColumn:
				cellText = generateCellText(result.tie, result.tiePercent)
				cellIdentifier = CellIdentifiers.TiesCell
			case lossesColumn:
				cellText = generateCellText(result.loss, result.lossPercent)
				cellIdentifier = CellIdentifiers.LossesCell
			case otherColumn:
				cellText = generateCellText(result.none, result.nonePercent)
				cellIdentifier = CellIdentifiers.OtherCell
			default:
				cellText = ""
				cellIdentifier = ""
		}
		
		let identifier = NSUserInterfaceItemIdentifier(cellIdentifier)
		
		if let cell = tableView.makeView(withIdentifier: identifier, owner: nil) as? NSTableCellView {
			cell.textField?.stringValue = cellText
			return cell
		}
		return nil
  }
}

