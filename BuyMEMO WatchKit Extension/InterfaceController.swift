//
//  InterfaceController.swift
//  BuyMEMO WatchKit Extension
//
//  Created by 小笠原 大樹 on 2015/05/30.
//  Copyright (c) 2015年 ogataiki. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var table: WKInterfaceTable!
    
    var rows = ["太郎😍", "花子🐽", "サンタクロース🎅", "あ", "i", "おすあふぇいwjふぁえw"]

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
        // tableの設定
        table.setNumberOfRows(rows.count, withRowType: "TableRowController");
        
        // tableRowのラベルにtableItemsの要素を表示
        for (index, item) in enumerate(rows){
            let controller = table.rowControllerAtIndex(index) as! TableRowController
            controller.BuyItem.setTitle(item);
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        self.pushControllerWithName("DetailController", context: self.rows[rowIndex])
    }

}
