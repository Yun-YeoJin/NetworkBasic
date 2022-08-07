//
//  LocationViewController.swift
//  NetworkBasic
//
//  Created by 윤여진 on 2022/07/29.
//

import UIKit

class LocationViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    // Notification 1.
    let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 커스텀 폰트
        for family in UIFont.familyNames {
            print("=========\(family)==========")
            
            for name in UIFont.fontNames(forFamilyName: family) {
                print(name)
            }
        }
        
        
    }
    @IBAction func downloadImageButtonClicked(_ sender: UIButton) {
        
        let url = "https://apod.nasa.gov/apod/image/2208/M13_final2_sinfirma.jpg"
        
        DispatchQueue.global().async { //동시에 여러 작업이 가능하게끔 해준다.
            
            print("2", Thread.isMainThread)
            let data = try! Data(contentsOf: URL(string: url)!) //url을 data에 넣기
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                print("3", Thread.isMainThread)
                self.imageView.image = image
            }
          
        }
        
        
    }
    
    // Notification 2. 권한 요청
    func requestAuthorization() {
        
        let authorizationOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        
        notificationCenter.requestAuthorization(options: authorizationOptions) { success, error in
            
            if success {
                self.sendNotification()
            }
        }
        
    }
    // Notification 3. 권한 허용한 사용자에게 알림 요청 (언제, 어떤 컨텐츠)
    // iOS 시스템에서 알림을 담당 -> 알림 등록을 해야함.
    
    /*
     
     - 권한 허용 해야만 알림이 온다.
     - 권한 허용 문구 시스템적으로 최초 한 번만 뜬다.
     - 허용 안 된 경우 애플 설정으로 직접 유도하는 코드를 구성해야 한다.
     
     - 기본적으로 알림은 포그라운드에서 수신되지 않는다.
     - 로컬 알림에서는 60초 이상이 되어야 반복이 가능하다. / 갯수 제한 : 64개 / 커스텀 사운드
     
     1. 뱃지 제거는 어찌?
     2. 노티 제거는 어찌? > 노티의 유효기간은? > 언제 지우는게 맞을지?
     3. 포그라운드 수신은 어찌? -> delegate 메서드로 해결!
     
     +++ 더 배우게 될것들
     - 노티는 앱 실행이 기본인데, 특정 노티를 클릭할 때 특정 화면으로 가고 싶다면?
     - 포그라운드 수신, 특정 화면에서는 안받고 특정 조건에 대해서만 포그라운드 수신을 하고 싶다면?
     
     */
    
    func sendNotification() {
        let notificationContent = UNMutableNotificationContent()
        
        notificationContent.title = "다마고치를 키워보세요"
        notificationContent.subtitle = "오늘 행운의 숫자는 \(Int.random(in: 1...100))입니다."
        notificationContent.body = "저는 따끔따끔 다마고치입니다."
        notificationContent.badge = 40
        
        // 언제 보낼지, 1. 시간간격, 2. 캘린더, 3. 위치에 따라 설정 가능
        //1. 시간간격
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        //2. 캘린더
        // var dateComponent = DateComponents()
        // dateComponent.minute = 15
        // let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        
        // 알림 요청 : identifier:
        // 만약 알림 관리 할 필요가 없으면 -> 알림 클릭하면 앱을 켜주는 정도
        // 알림 관리할 필요가 있으면 -> 고유이름, 규칙 등
        
        let request = UNNotificationRequest(identifier: "\(Date())", content: notificationContent, trigger: trigger)
        
        notificationCenter.add(request)
    }
    
    @IBAction func notificationButtonClicked(_ sender: UIButton) {
        requestAuthorization()
    }
}
