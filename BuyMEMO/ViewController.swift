import UIKit

class ViewController: UIViewController
    , UITableViewDelegate
    , UITableViewDataSource
{
    @IBOutlet weak var buyTableView: UITableView!
    
    var buyList: [String]!;

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addBuyItemInputView(text: String = "")
    {
        var textAlert = UIAlertController(title: "買うものを入力"
            , message: ""
            , preferredStyle: UIAlertControllerStyle.Alert);
        
        textAlert.addTextFieldWithConfigurationHandler { (tf: UITextField!) -> Void in
            tf.placeholder = "買うもの";
            tf.text = text;
        };
        
        let defaultAction:UIAlertAction = UIAlertAction(title: "決定",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction!) -> Void in
                
                var textField = textAlert.textFields?.first as! UITextField;
                self.buyList.append(textField.text);
                self.buyTableView.reloadData();
        })
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "やめる",
            style: UIAlertActionStyle.Cancel,
            handler:{
                (action:UIAlertAction!) -> Void in
        })
        
        textAlert.addAction(defaultAction);
        textAlert.addAction(cancelAction);
        
        presentViewController(textAlert, animated: true, completion: nil);
    }

    @IBAction func addBuyItem(sender: UIBarButtonItem) {
        
        addBuyItemInputView();
        
    }
    
    @IBAction func resetList(sender: AnyObject) {
        buyList.removeAll(keepCapacity: false);
        buyTableView.reloadData();
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return buyList.count;
    }
    
    // Cellが選択された際に呼び出される.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        addBuyItemInputView(text: "\(buyList[indexPath.row])");
    }
    
    // Cellに値を設定する
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("BuyItem", forIndexPath: indexPath) as! UITableViewCell;
        
        // Cellに値を設定.
        cell.textLabel?.text = "\(buyList[indexPath.row])";
        
        return cell;
    }
    
    // Cellを挿入または削除しようとした際に呼び出される
    func tableView(tableView: UITableView
        , commitEditingStyle editingStyle: UITableViewCellEditingStyle
        , forRowAtIndexPath indexPath: NSIndexPath)
    {
        // 削除のとき.
        if editingStyle == UITableViewCellEditingStyle.Delete
        {
            buyList.removeAtIndex(indexPath.row);
            buyTableView.reloadData()
        }
    }
    
}

