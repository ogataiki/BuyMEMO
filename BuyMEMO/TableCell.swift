import UIKit

protocol TableCellDelegate {
    func changeSwitch(key: String, value: Bool) -> Void;
}

class TableCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var boughtSwitch: UISwitch!
    
    @IBAction func switchChange(sender: AnyObject) {
        
        var bought = (sender as! UISwitch).on;
        if let del = delegate
        {
            delegate.changeSwitch(titletext, value: bought);
        }
    }
    
    var delegate: TableCellDelegate!;
    func setDelegate(del: TableCellDelegate)
    {
        delegate = del;
    }
    
    var titletext: String = "";
    func setTitle(value: String)
    {
        titletext = value;
        label.text = value;
    }
    
    func setSwitch(value: Bool)
    {
        boughtSwitch.setOn(value, animated: true);
    }
    func getSwitch() -> Bool
    {
        return boughtSwitch.on;
    }
    
    func invalidSwitch(value: Bool)
    {
        boughtSwitch.hidden = value;
    }
}