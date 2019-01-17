//
//  signInVC.swift
//  FirebaseInstaClone
//
//  Created by Erdo on 15.01.2019.
//  Copyright © 2019 Erdo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class signInVC: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func signInClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (userdata, error) in
                if error != nil{
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                } else{
                    //userdefault ile coredata gibi veri kayıt edebiliyoruz ayrıca kullanıcının giriş yaptığını kayıt edicez
                    UserDefaults.standard.set(userdata!.user.email, forKey: "user")
                    UserDefaults.standard.synchronize()
                    //self.performSegue(withIdentifier: "toTabBar", sender: nil)
                    //segue yapmaya gerek kalmadı çünkü rememberuser func ile oku taşıdık kullanıcı giriş yapmışsa diye aynı şeyi sign upda da yaparız kayıtlı bir şey girmiş mi diye.
                    let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.rememberUser()
                }
            }
        }else {
            let alert = UIAlertController(title: "Error", message: "Please Enter Email/Password", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
        //ToastView.shared.long(self.view, txt_msg: "Welcome ")
    }
    
   
    @IBAction func signUpCliked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {  //email ve şifre boş değilse yap
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (userdata, error) in  //değer dödüreceği için userdata dedik complition(Authdataresult callback yerine) yerine.Ayrıca cevap veriyor userdata ve error getiriyor.
                if error != nil { //firebaseden hata dönerse firebase hatasını göster
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }else{ //kullanıcı başarılı kayıtlanırsa diğer ekrana geç
                    //self.performSegue(withIdentifier: "toTabBar", sender: nil)
                    UserDefaults.standard.set(userdata!.user.email, forKey: "user")
                    UserDefaults.standard.synchronize()
                    let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.rememberUser()
                    //ToastView.shared.long(self.view, txt_msg: "Welcome \(self.emailText.text) ")
                }
            }
            
        }else{ //boş girerse kullanıcı alert göster
            let alert = UIAlertController(title: "Error", message: "Please Enter Email/Password", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
}
