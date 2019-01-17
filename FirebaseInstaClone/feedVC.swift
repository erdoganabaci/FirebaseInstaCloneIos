//
//  FirstViewController.swift
//  FirebaseInstaClone
//
//  Created by Erdo on 15.01.2019.
//  Copyright © 2019 Erdo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SDWebImage
class feedVC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var userImageArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        getDataFromFirebase()
        
    }
    func getDataFromFirebase () {
        let databaseReference = Database.database().reference()
        databaseReference.child("users").observe(DataEventType.childAdded) { (snapshot) in //DataEventType.childAdded bu cocuk eklendiğinde yaptık demesekte oluyor önemli olan snapshot ile tüm değerleri aldık sonra postun keyi ondan sonra onun keyi diye gidicez.
            //print("snapshot value \(snapshot.value)") //hep bir kademe altına inerek değerleri filtreliyoz
            let values = snapshot.value! as! NSDictionary
            //print("values : \(values)") valuenin içinde post var key olarak şimdi onu çekip içindeki keyleri alcaz
            let post = values["post"] as! NSDictionary
            //print("Post edilen : \(post)")
            let postID = post.allKeys //tüm postların keylerini aldık onu döngüye sokup her keyin içinden istediğimizi alıcaz ama post dictioanrye o keyi verip öyle belirli şeyleri alcaz
            //print("Post idileri : \(postID)") //her keyi döngüye sokup o keyin istediğimiz değerini alıcaz
            
            for id in postID{
                let singlePost = post[id] as! NSDictionary
                //let postText = singlePost["posttext"] as! String //gelen tüm posttextleri string olarak alcaz en son aşamada
                //print("Postlarım \(postText)")
                //değişkenleri tek tek oluşturmaya gerek yok ondan direk arraye eklicez.
                self.userCommentArray.append(singlePost["posttext"] as! String)
                self.userEmailArray.append(singlePost["postedby"] as! String )
                self.userImageArray.append(singlePost["image"] as! String )
            }
            self.tableView.reloadData() //tableview baştan çekilen verilerle yenileniyor.
            //Sdwebimage ile resimleri hızlıca yüklicez
        
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! feedCell //celle atadığımız hücre adı Cell olarak dedik ve hangi sınıfı kullancağını cast ederiz feedCell sınıfıyla cellerin sınıfı
        //her bi cellin emaililabelını ve commentlabelını düzeltiyoruz.Yani arraylerin içindekiyle değiştircez.
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.userCommentLabel.text = userCommentArray[indexPath.row]
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]) )
        
        
        return cell //asıl amac hücreleri değiştirmek
    }
    @IBAction func logoutCliked(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey:"user")
        UserDefaults.standard.synchronize()
        
        //Storyboardu bu sefer classlar arasından direk self ile çağırabiliyoruz.
        let signIn = self.storyboard?.instantiateViewController(withIdentifier: "signIn") as! signInVC //burda başlangıç view conrollerı seçtik window ile oku signin e atıcaz
        let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.rootViewController = signIn
        delegate.rememberUser() //içi boşsa ellemiyor.ilk ok nerdeyse oraya götürüyor
        
        do {
            try Auth.auth().signOut() //firebase sistemi anlasın diye firebaseden çıktığını anlıyor logouta basılırsa.
        } catch  {
            print("Error...")
        }
    }
    
}

