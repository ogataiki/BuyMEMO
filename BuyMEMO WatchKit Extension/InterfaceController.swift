import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var table: WKInterfaceTable!
    
    var buyList: [String] = [];

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
        buyListUpdate()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        buyListUpdate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
    }
    
    @IBAction func buttonAction_updateList() {
        
        buyListUpdate();
    }
    
    // 購入リストの更新
    func buyListUpdate()
    {
        //iPhone側の親アプリ呼び出し
        WKInterfaceController.openParentApplication(["content": ""],
            reply: {obj, error in
                
                self.buyList = obj["buylist"] as! [String];
                
                // tableの設定
                self.table.setNumberOfRows(self.buyList.count, withRowType: "TableRowController");
                
                // tableRowのラベルにtableItemsの要素を表示
                for (index, item) in enumerate(self.buyList){
                    let controller = self.table.rowControllerAtIndex(index) as! TableRowController
                    controller.BuyItem.setTitle(item);
                }
        })
    }

}
