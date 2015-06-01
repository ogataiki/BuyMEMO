import UIKit

class ViewController: UIViewController
    , UITableViewDelegate
    , UITableViewDataSource
{
    @IBOutlet weak var buyTableView: UITableView!
    
    var buyList: [String] = [];
    
    enum BUYITEM_EDITMODE: Int {
        case add = 0, edit
    }
    struct EDITBUYITEM {
        var buyItemEditMode: BUYITEM_EDITMODE;
        var editIndex: Int;
    }
    var editBuyItem = EDITBUYITEM(buyItemEditMode: BUYITEM_EDITMODE.add, editIndex: 0);
    
    let buyListSaveKey = "buylist";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if((NSUserDefaults.standardUserDefaults().objectForKey(buyListSaveKey)) != nil){
            if var arr = NSUserDefaults.standardUserDefaults().objectForKey(buyListSaveKey) as? [String]
            {
                // 読み込みOK
                buyList = arr;
            }
            else
            {
                buyList = [];
            }
        }
        
        buyTableView.delegate = self;
        buyTableView.dataSource = self;
        buyTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "BuyItem")
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
                if(self.editBuyItem.buyItemEditMode == BUYITEM_EDITMODE.edit)
                {
                    self.buyList[self.editBuyItem.editIndex] = textField.text;
                }
                else
                {
                    self.buyList.append(textField.text);
                }
                
                NSUserDefaults.standardUserDefaults().setObject(self.buyList, forKey:self.buyListSaveKey);
                NSUserDefaults.standardUserDefaults().synchronize();
                
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
        
        editBuyItem.buyItemEditMode = BUYITEM_EDITMODE.add;
        editBuyItem.editIndex = 0;
        addBuyItemInputView();
        
    }
    
    @IBAction func resetList(sender: AnyObject) {
        buyList.removeAll(keepCapacity: false);
        buyTableView.reloadData();
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return buyList.count + 1;
    }
    
    // Cellが選択された際に呼び出される.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.row == buyList.count)
        {
            editBuyItem.buyItemEditMode = BUYITEM_EDITMODE.add;
            editBuyItem.editIndex = 0;
            addBuyItemInputView();
        }
        else
        {
            editBuyItem.buyItemEditMode = BUYITEM_EDITMODE.edit;
            editBuyItem.editIndex = indexPath.row;
            addBuyItemInputView(text: "\(buyList[indexPath.row])");
        }
    }
    
    // Cellに値を設定する
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("BuyItem", forIndexPath: indexPath) as! UITableViewCell;
        
        // Cellに値を設定.
        if(indexPath.row == buyList.count)
        {
            cell.textLabel?.text = "【タップして買うものを追加】";
        }
        else
        {
            cell.textLabel?.text = "\(buyList[indexPath.row])";
        }
        
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
            if(indexPath.row < buyList.count)
            {
                buyList.removeAtIndex(indexPath.row);
                
                NSUserDefaults.standardUserDefaults().setObject(self.buyList, forKey:self.buyListSaveKey);
                NSUserDefaults.standardUserDefaults().synchronize();

                buyTableView.reloadData()
            }
        }
    }
    
}

