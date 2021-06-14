//
//  TableInterfaceController.swift
//  WatchAppTest WatchKit Extension
//
//  Created by Никита Лужбин on 14.06.2021.
//

import WatchKit
import Foundation

class TableRow: NSObject {

    // MARK: - Instance Properties

    @IBOutlet weak var textLabel: WKInterfaceLabel!
}


class TableInterfaceController: WKInterfaceController {

    // MARK: - Insatnce Properties

    @IBOutlet private weak var table: WKInterfaceTable!

    // MARK: -

    private var dataSource: [String] = ["1", "2", "3", "4"]

    // MARK: - Instance Methods

    private func setupTable() {
        self.table.setNumberOfRows(self.dataSource.count, withRowType: "cell")

        for (index, item) in self.dataSource.enumerated() {
            if let row = self.table.rowController(at: index) as? TableRow {
                row.textLabel.setText(item)
            }
        }
    }

    // MARK: - WKInterfaceController

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.setupTable()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        print("Selected ad index: \(rowIndex)")
    }
}
