//
//  Helper.swift
//  WeLoveReadingVolunteer
//
//  Created by Saad Basha on 11/3/16.
//  Copyright © 2016 Saad Basha. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import QuartzCore
import MBProgressHUD


enum TextFieldValidationType: Int {
    case     emailValidation,            // 0
    nameValidation,             // 1
    phoneNumberValidation,      // 2
    passwordValidation,         // 3
    noneValidation             // 4
}


@objc class Helper : NSObject  {
    
    static let sharedInstance = Helper()
    var isChangingLanguage = false
    static var isWallGroup = false
    static var progreesHUD:MBProgressHUD?
    
    fileprivate override init(){
        
    }
    
    // MARK: Colors
    
    func makePaddingForTextFields(textField:UITextField){
        
            let paddingView = UIView(frame:CGRect(x:0,y: 0,width: 5,height: textField.frame.size.height))
            textField.leftView = paddingView;
            textField.leftViewMode = UITextFieldViewMode.always
            textField.rightView = paddingView
            textField.rightViewMode = UITextFieldViewMode.always
        
    }
    
    func colorWithHexString (_ hex:String) -> UIColor {
        
        
        var cString:String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            let startIndex = cString.characters.index(cString.startIndex, offsetBy: 1)
            cString = cString.substring(from: startIndex)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.gray
        }
        
        let rString = cString.substring(to: cString.characters.index(cString.startIndex, offsetBy: 2))
        let gString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 2)).substring(to: cString.characters.index(cString.startIndex, offsetBy: 2))
        let bString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 4)).substring(to: cString.characters.index(cString.startIndex, offsetBy: 2))
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string:gString).scanHexInt32(&g)
        Scanner(string:bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    
    
    func appTintColor()->UIColor{
        
        return UIColor(red: 255/255, green: 215/255, blue: 58/255, alpha: 1.0)
        
    }
    
    func appYellowTintColor()->UIColor{
        
        return colorWithHexString("D8D1CA")

        
    }
    
    func backgroundGrayColor()-> UIColor{
        
        return UIColor(red: 231/255, green: 232/255, blue: 232/255, alpha: 1.0)
    }
    
    func textGrayColor()-> UIColor{
        
        return UIColor(red: 188/255, green: 188/255, blue: 189/255, alpha: 1.0)
    }

    
    // MARK: Validation
    
    func validateInputInTextField(_ textfield:UITextField, withType validationType:TextFieldValidationType)->Bool{
        
        switch (validationType.rawValue) {
        case 0:
            
            let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            
            return emailTest.evaluate(with: textfield.text)
            
        case 1:
            
            let nameRegex = "^[A-Za-z\\s-0-9]{0,128}"
            let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)
            
            return nameTest.evaluate(with: textfield.text)
            
        case 2:
            
            let phoneRegex = "(([0]{2})|[+]{1})(\\d{12,14})"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            
            return phoneTest.evaluate(with: textfield.text)
            
        case 3:
            
            let passwordRegex = "^[A-Za-z0-9]{8,24}"
            let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
            
            return passwordTest.evaluate(with: textfield.text)
            
        case 4:
            return true;
            
        default:
            return true;
        }
    }

    //MARK: - Navigation Controller Animation
    
    func prepareAnimationForPush(NavigationController navigation:UINavigationController){
        
        if LanguageManager.sharedInstance.language == .arabic {
            
            let transition = CATransition()
            transition.duration = 0.40;
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionMoveIn;
            transition.subtype = kCATransitionFromLeft;
            
            navigation.view.layer.add(transition, forKey: kCATransition)
            
        }else {
            
            let transition = CATransition()
            transition.duration = 0.40;
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionMoveIn;
            transition.subtype = kCATransitionFromRight;
            
            navigation.view.layer.add(transition, forKey: kCATransition)
            
        }
        
        
    }
    
    
    
    func prepareAnimationForPop(NavigationController navigation:UINavigationController){
        
        if LanguageManager.sharedInstance.language == .arabic {
            
            let transition = CATransition()
            transition.duration = 0.40;
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionMoveIn;
            transition.subtype = kCATransitionFromRight;
            
            navigation.view.layer.add(transition, forKey: kCATransition)
            
        }else {
            
            let transition = CATransition()
            transition.duration = 0.40;
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionMoveIn;
            transition.subtype = kCATransitionFromLeft;
            
            navigation.view.layer.add(transition, forKey: kCATransition)
            
            
        }
        
        
    }
    
    //MARK: - Alerts and messages
    
    func showAlertWithTitle(_ title:String,message:String,cancelButtonTitle:String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okButton = UIAlertAction(title: cancelButtonTitle, style: UIAlertActionStyle.cancel) { (action) in
            
            
            
        }
        alertController.addAction(okButton)
        
        let delayTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            
            self.topMostViewController().present(alertController, animated: true, completion: nil)
            
        }
        
        
    }
    
    func showAlertWithTitle(_ title:String,message:String,cancelButtonTitle:String,cancelCompletionBlock: @escaping () -> (Void)){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okButton = UIAlertAction(title: cancelButtonTitle, style: UIAlertActionStyle.cancel) { (action) in
            
            cancelCompletionBlock()
            
        }
        alertController.addAction(okButton)
        
        let delayTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            
            self.topMostViewController().present(alertController, animated: true, completion: nil)
            
        }
        
        
    }
    
    
    
    
    func showAlertWithTitle(_ title:String,message:String,okButtonTitle:String,okCompletionBlock: @escaping () -> (Void),cancelButtonTitle:String,cancelCompletionBlock: @escaping () -> (Void)){
        
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okButton = UIAlertAction(title: okButtonTitle, style: UIAlertActionStyle.default) { (action) in
            
            okCompletionBlock()
            
        }
        
        let cancelButton = UIAlertAction(title: cancelButtonTitle, style: UIAlertActionStyle.cancel) { (action) in
            
            cancelCompletionBlock()
            
        }
        
        if LanguageManager.sharedInstance.language == .arabic {
            
            alert.addAction(cancelButton)
            alert.addAction(okButton)
            
        }else{
            
            alert.addAction(okButton)
            alert.addAction(cancelButton)
        }
        
        
        let delayTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            
            self.topMostViewController().present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    //MARK: - Helping
    
    func topMostViewController()->UIViewController{
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
            // topController should now be your topmost view controller
        }
        
        return UIViewController()
    }
    
    
    
    func fixOrientationFor(_ src:UIImage)->UIImage {
        
        if src.imageOrientation == UIImageOrientation.up {
            return src
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch src.imageOrientation {
        case UIImageOrientation.down, UIImageOrientation.downMirrored:
            transform = transform.translatedBy(x: src.size.width, y: src.size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
            break
        case UIImageOrientation.left, UIImageOrientation.leftMirrored:
            transform = transform.translatedBy(x: src.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
            break
        case UIImageOrientation.right, UIImageOrientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: src.size.height)
            transform = transform.rotated(by: CGFloat(-M_PI_2))
            break
        case UIImageOrientation.up, UIImageOrientation.upMirrored:
            break
        }
        
        switch src.imageOrientation {
        case UIImageOrientation.upMirrored, UIImageOrientation.downMirrored:
            transform.translatedBy(x: src.size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImageOrientation.leftMirrored, UIImageOrientation.rightMirrored:
            transform.translatedBy(x: src.size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImageOrientation.up, UIImageOrientation.down, UIImageOrientation.left, UIImageOrientation.right:
            break
        }
        
        let ctx:CGContext = CGContext(data: nil, width: Int(src.size.width), height: Int(src.size.height), bitsPerComponent: src.cgImage!.bitsPerComponent, bytesPerRow: 0, space: src.cgImage!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        ctx.concatenate(transform)
        
        switch src.imageOrientation {
        case UIImageOrientation.left, UIImageOrientation.leftMirrored, UIImageOrientation.right, UIImageOrientation.rightMirrored:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.height, height: src.size.width))
            break
        default:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.width, height: src.size.height))
            break
        }
        
        let cgimg:CGImage = ctx.makeImage()!
        let img:UIImage = UIImage(cgImage: cgimg)
        
        return img
    }
    
    func trimDeviceToken(_ deviceTokenData:Data)->NSString {
        
        return NSString(format: "%@", deviceTokenData as CVarArg).replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "") as NSString
        
    }
    
    func showNoResultLabel(tableView:UITableView ,placeHolderText:NSString){
        
        //* Display a message when the table is empty
        
        let noResultLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        noResultLabel.text = placeHolderText as String
        noResultLabel.textColor = Helper.sharedInstance.colorWithHexString("F4C449")
        noResultLabel.numberOfLines = 0
        noResultLabel.textAlignment = NSTextAlignment.center
        noResultLabel.font = UIFont.systemFont(ofSize: 20)
        noResultLabel.sizeToFit()
        
        tableView.backgroundView = noResultLabel
    }
    
    func clearNoResultLabel(tableView:UITableView){
        
        //* Display a message when the table is empt
        
        tableView.backgroundView = UIView()
    }
    
    // MARK: - Image utilities
    
    static func resizeImage (sourceImage:UIImage, scaledToWidth: CGFloat) -> UIImage {
        
        let oldWidth = sourceImage.size.width
        let scaleFactor = scaledToWidth / oldWidth
        
        let newHeight = sourceImage.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor
        
        UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
        sourceImage.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    //MARK: logout and direct user to first lanuch screen
    
    func logoutUser(_ presentingViewController:UIViewController,tabBarController:UITabBarController,storyboard:UIStoryboard){
        
        removeDataOnLogout()
        
        // direct user to login
        let superVC = presentingViewController
        let navigationVC = storyboard.instantiateViewController(withIdentifier: "StartupViewController") as! UINavigationController
        
        tabBarController.dismiss(animated: false, completion: {
            
            superVC.present(navigationVC, animated: false, completion: nil)
            
        })
        
        
    }
    
    
    
    func presentLaunchScreen(){
        
        removeDataOnLogout()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationVC = storyboard.instantiateViewController(withIdentifier: "StartupViewController") as! UINavigationController
        UIApplication.shared.keyWindow!.visibleViewController()?.present(navigationVC, animated: false, completion: nil)
        
    }
    
    
    func removeDataOnLogout(){
        
        //        Manager.sharedInstance.didLogout = true
        //
        //            // runregister notifications
        //        UIApplication.shared.unregisterForRemoteNotifications()
        //
        //        // remove data
        //        let appDomain = Bundle.main.bundleIdentifier
        //        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
        //
        //
        //        APIClient.sharedInstance.clearHeadersOnLogout()
    }
    
    
    func logoutByForce(){
        
        //        if let topController = UIApplication.shared.keyWindow!.visibleViewController() {
        //
        //            print(topController)
        //
        //            if !topController.isKind(of: Manager.sharedInstance.selectedTabBarVC.classForCoder){
        //
        //                if topController.presentingViewController?.presentedViewController == topController {
        //
        //                    topController.dismiss(animated: false, completion: {
        //
        //                        self.logoutByForce()
        //
        //                    })
        //
        //                }else {
        //                    _ = topController.navigationController?.popViewController(animated: false)
        //                    logoutByForce()
        //                }
        //
        //            }else {
        //
        //                topController.performSegue(withIdentifier: "logoutToLaunchScreen", sender: topController)
        //
        //            }
        //
        //        }
    }
    
    
    
    //MARK: PhotoLibrary and Camera Permissions
    
    func requestCameraPermissions(){
        
        
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) ==  AVAuthorizationStatus.authorized{
            // Already Authorized
            
        }else{
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted :Bool) -> Void in
                if granted == true{
                    
                }else{
                    // access denied
                }
            });
        }
        
        
    }
    
    func checkCameraRollPermissionAndRequestIfNeeded()->PHAuthorizationStatus {
        
        var rollStatus = PHPhotoLibrary.authorizationStatus()
        
        
        if(rollStatus == PHAuthorizationStatus.authorized) { // authorized
            print("Camera roll Permission authorized");
        } else if(rollStatus == PHAuthorizationStatus.denied){ // denied
            print("Camera roll Permission denied");
        } else if(rollStatus == PHAuthorizationStatus.restricted){ // restricted
            print("Camera roll Permission restricted");
        } else if(rollStatus == PHAuthorizationStatus.notDetermined){ // not determined
            
            
            print("Camera roll Permission not determined");
            
            
            PHPhotoLibrary.requestAuthorization({ (status) in
                
                
                rollStatus = status
                
                switch (rollStatus) {
                case PHAuthorizationStatus.authorized:
                    print("Camera roll Permission authorized");
                    break;
                case PHAuthorizationStatus.restricted:
                    print("Camera roll Permission restricted");
                    break;
                case PHAuthorizationStatus.denied:
                    print("Camera roll Permission denied");
                    break;
                case PHAuthorizationStatus.notDetermined:
                    print("Camera roll Permission not determined");
                    break;
                }
                
                
            })
            
        }
        
        return rollStatus;
    }
    
//    + (NSAttributedString *)attributedStringFromHtmlText:(NSString *)htmlString {
//    
//        NSAttributedString *stringWithHTMLAttributes = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
//    
//        return stringWithHTMLAttributes;
//    }
    
    
    
    func attributedString(fromHtmlText htmlString: String) -> NSAttributedString?{
        
        
        return AttributedTextHelper.attributedString(fromHtmlText: htmlString)
        
//        var attributedString:NSAttributedString?
//        
//        if let data = htmlString.data(using: .utf8) {
//            
//            do{
//                try attributedString = NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8], documentAttributes: nil)
//            }catch{
//                
//            }
//            
//        }
//        
//        return attributedString
    }
   
    
    
    
}

//MARK: - Extentions

extension UIWindow {
    
    
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController  = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(rootViewController)
        }
        return nil
    }
    
    class func getVisibleViewControllerFrom(_ vc:UIViewController) -> UIViewController {
        
        if vc.isKind(of: UINavigationController.self) {
            
            let navigationController = vc as! UINavigationController
            return UIWindow.getVisibleViewControllerFrom( navigationController.visibleViewController!)
            
        } else if vc.isKind(of: UITabBarController.self) {
            
            let tabBarController = vc as! UITabBarController
            return UIWindow.getVisibleViewControllerFrom(tabBarController.selectedViewController!)
            
        } else {
            
            if let presentedViewController = vc.presentedViewController {
                
                return UIWindow.getVisibleViewControllerFrom(presentedViewController)
                
            } else {
                
                return vc;
            }
        }
    }
    
    
}

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}


extension String {
    
    enum AttributedStringType {
        case title
        case titleRegular
        case description
        case storyDescription
        case message
    }
    
    func htmlAttributedString(stringType: AttributedStringType) -> NSAttributedString? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil) else { return nil }
        
        var attributes:[String: Any]?
       
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = LanguageManager.sharedInstance.language == .english ? .left : .right
        
        switch stringType {
            
        case .title:
            
            attributes = [NSFontAttributeName: UIFont(name: "Roboto-Bold", size: 13) ?? UIFont.systemFont(ofSize: 13), NSForegroundColorAttributeName: UIColor(red: 111/255, green: 113/255, blue: 121/255, alpha: 1), NSParagraphStyleAttributeName: paragraphStyle ]
        
        case .titleRegular:
            
            attributes = [NSFontAttributeName: UIFont(name: "Roboto-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13), NSForegroundColorAttributeName: UIColor(red: 111/255, green: 113/255, blue: 121/255, alpha: 1) , NSParagraphStyleAttributeName: paragraphStyle]
            
        case .description:
            
           attributes = [NSFontAttributeName: UIFont(name: "Roboto-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1), NSParagraphStyleAttributeName: paragraphStyle ]
            
        case .storyDescription:
            
            attributes = [NSFontAttributeName: UIFont(name: "Roboto-Bold", size: 13) ?? UIFont.systemFont(ofSize: 13), NSForegroundColorAttributeName: UIColor(red: 111/255, green: 113/255, blue: 121/255, alpha: 1), NSParagraphStyleAttributeName: paragraphStyle ]
            
        case .message:
            
            attributes = [NSFontAttributeName: UIFont(name: "Roboto-Bold", size: 14) ?? UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.white, NSParagraphStyleAttributeName: paragraphStyle ]
        }
        
        
        html.addAttributes(attributes!, range:NSMakeRange(0, html.length))
        
        
        return html
    }
    
}

extension UITableView {
    
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
    
   
}
