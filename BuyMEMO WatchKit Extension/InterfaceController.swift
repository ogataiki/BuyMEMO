import WatchKit
import Foundation


class InterfaceController: WKInterfaceController, BuyItemDelegate {

    @IBOutlet weak var table: WKInterfaceTable!
    
    @IBOutlet weak var footerLabel: WKInterfaceLabel!
    
    var buyList: [String] = [];
    var boughtList: [String: Bool] = [:];

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
        footerLabel.setText(NSLocalizedString("addItemWatch", comment: "iPhoneからリストを追加できます。"));
        
        buyListUpdate()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        footerLabel.setText(NSLocalizedString("addItemWatch", comment: "iPhoneからリストを追加できます。"));

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
        WKInterfaceController.openParentApplication([:],
            reply: {obj, error in
                
                self.buyList = obj["buylist"] as! [String];
                self.boughtList = obj["boughtlist"] as! [String: Bool];
                
                // tableの設定
                self.table.setNumberOfRows(self.buyList.count, withRowType: "TableRowController");
                
                // tableRowのラベルにtableItemsの要素を表示
                for (index, item) in enumerate(self.buyList){
                    let controller = self.table.rowControllerAtIndex(index) as! TableRowController
                    controller.setTitle(item);
                    controller.setDelegate(self);
                    
                    if let bought = self.boughtList[item]
                    {
                        controller.setSwitch(bought);
                    }
                }
        })
    }

    // リストのスイッチがタップされた
    func changeSwitch(key: String, value: Bool)
    {
        //iPhone側へ購入済み情報を送る
        WKInterfaceController.openParentApplication(["bought": [key: value]],
            reply: {obj, error in
                
                //特に何もしない
        })
    }

}
