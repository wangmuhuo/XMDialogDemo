# XMDialogDemo 
IOS 基于Swift的弹出提示框(仿Android的Toast 和等待提示框)
使用示例代码
class ViewController: UIViewController {

    // 创建HUD管理器，一个管理器管理同一时刻只能控制一个HUD显示，需要同时显示多个需要创建多个管理器
    let hudManager: XMIndicatorDialogUtils = XMIndicatorDialogUtils()
    
    @IBAction func showToast(sender: UIButton) {
        // 创建并显示Toast
        XMToast.create("我是Toast，2秒后自动消失").show()
    }
    
    @IBAction func showIndicator(sender: UIButton) {
        // 显示HUD
        hudManager.showDialog("我是HUD...")
        // 示例中，2秒后移除HUD，实际可以通过情况自行控制
        delayerOnMain(2) { [weak self] in self?.hudManager.hideDialog() }
    }
    
}

效果

![image](https://github.com/wangmuhuo/XMDialogDemo/tree/master/XMDialogDemo/demoRes/Demo.gif) 


介绍文章：http://blog.csdn.net/jejay/article/details/67118558
