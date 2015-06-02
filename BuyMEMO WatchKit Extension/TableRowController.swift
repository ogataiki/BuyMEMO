import UIKit
import WatchKit

protocol BuyItemDelegate {
    func changeSwitch(key: String, value: Bool) -> Void;
}
class TableRowController: NSObject {
    
    @IBOutlet weak var BuyItem: WKInterfaceSwitch!
    
    var delegate: BuyItemDelegate!;
    func setDelegate(del: BuyItemDelegate)
    {
        delegate = del;
    }

    var titletext: String = "";
    func setTitle(value: String)
    {
        titletext = value;
        BuyItem.setTitle(titletext);
    }
    
    func setSwitch(value: Bool)
    {
        BuyItem.setOn(value);
    }

    @IBAction func TapSwitch(value: Bool) {
        // スイッチ切り替えた
        if let del = delegate
        {
            delegate.changeSwitch(titletext, value: value);
        }
    }
    
}