//
//  InstructionVC.swift
//  PAL
//
//  Created by i-Verve on 20/10/21.
//

import UIKit
import AVFoundation

class InstructionVC: UIViewController, UITableViewDelegate, UITableViewDataSource, AVSpeechSynthesizerDelegate {
    
    //MARK: - Outlet
    @IBOutlet weak var tblInstruction: UITableView!
    @IBOutlet weak var btnText: UIButton!
    @IBOutlet weak var btnVoice: UIButton!
    @IBOutlet weak var objViewupeer: UIView!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var btnHeight: NSLayoutConstraint!
    @IBOutlet weak var btnTop: NSLayoutConstraint!
    @IBOutlet weak var lblInstruction: UILabel!
    @IBOutlet weak var LebalHeight: NSLayoutConstraint!
    
    
    //MARK: - Local
    var arrInstruction = [String]()
    var arrvoiceInstruction = [String]()
//    var selectedIndex: Int = 99999
    var SelectedbtnText = Bool()
    var numberRecord = 0
    var arrstrVoice = [Int]()
    var isFromStudent = false
    var numberOfRecords = 0
    let synthesizer = AVSpeechSynthesizer()
    var arrVoiceInstructionStr = [String]()
    var arridVoiceInstruction = [Int]()
    var workSheetId = 0
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        synthesizer.delegate = self
        print(arrvoiceInstruction)
        for i in arrvoiceInstruction{
            numberRecord = numberRecord + 1
            arridVoiceInstruction.append(numberRecord)
        }
        tblInstruction.reloadData()
        if self.arrInstruction.count > 0
        {
            lblNoData.isHidden = true
        }else{
            lblNoData.isHidden = false
        }
        self.objViewupeer.layer.cornerRadius = 15
        self.objViewupeer.layer.borderWidth = 1
        self.objViewupeer.layer.borderColor = UIColor.kAppThemeColor().cgColor
        btnSelected(btn: btnText)
        btnUnSelected(btn: btnVoice)
        self.SelectedbtnText = true
        
        if isFromStudent {
            lblInstruction.isHidden = false
            self.btnText.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 12)
            self.btnVoice.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 12)
            lblInstruction.font = UIFont.Font_ProductSans_Bold(fontsize: 12)
            LebalHeight.constant = 30
            self.btnText.setTitle("Text", for: .normal)
            self.btnVoice.setTitle("Voice", for: .normal)
            btnHeight.constant = 30
            btnTop.constant = 0
            NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationOver(notification:)), name: Notification.Name("NotificationOver"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationSpeech(notification:)), name: Notification.Name("NotificationSpeech"), object: nil)
            if appdelegate.btnSelectedVoice == true{
                btnSelected(btn: btnVoice)
                btnUnSelected(btn: btnText)
                self.SelectedbtnText = false
            }else{
                btnSelected(btn: btnText)
                btnUnSelected(btn: btnVoice)
                self.SelectedbtnText = true
            }
        }else{
            self.btnText.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
            self.btnVoice.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
            btnHeight.constant = 60
            btnTop.constant = 20
            LebalHeight.constant = 0
            lblInstruction.isHidden = true
        }
        self.tblInstruction.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isFromStudent == false
        {
            synthesizer.stopSpeaking(at: .immediate)
            MusicPlayer.instance.pause()
        }
    }

    
    //Function that gets path to directoary
    func getDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let aFolder = paths.appendingPathComponent("WorkSheetMetaData")
        let bFolder = aFolder.appendingPathComponent("\(workSheetId)")
        let cFolder = bFolder.appendingPathComponent("AudioRecording")
        return cFolder
    }
    

    
    func GetVoiceInstaruction()
    {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                                       includingPropertiesForKeys: nil,
                                                                       options: .skipsHiddenFiles)
            for fileURL in fileURLs where fileURL.pathExtension == "m4a" {
            
                let name = URL(fileURLWithPath: fileURL.path).lastPathComponent
                let substring1 = name.dropLast(4)
                print(substring1)
                print(name)
           //     self.arrVoiceInstruction.append(Int(substring1) ?? 0)
            }
        } catch  {
            print(error)
            
        }
        var stri = 1
//        for _ in arrVoiceInstruction {
//            arridVoiceInstruction.append(stri)
//            stri += 1
//        }
//        self.tblInstruction.reloadData()
    }


    
    @objc func methodOfReceivedNotificationOver(notification: Notification) {
        appdelegate.selectedIndex = 99999
        self.tblInstruction.reloadData()
    }
    @objc func methodOfReceivedNotificationSpeech(notification: Notification) {
        synthesizer.stopSpeaking(at: .immediate)
        appdelegate.selectedIndex = 99999
        self.tblInstruction.reloadData()
    }
    
    @IBAction func btnTextInstructionClick(_ sender: Any) {
        btnSelected(btn: btnText)
        btnUnSelected(btn: btnVoice)
        self.SelectedbtnText = true
        appdelegate.selectedIndex = 99999
//        appdelegate.player?.pause()
        if self.arrInstruction.count > 0
        {
            lblNoData.isHidden = true
        }else{
            lblNoData.isHidden = false
        }
        self.tblInstruction.reloadData()
    }
    
    @IBAction func btnVoiceInstructionClick(_ sender: Any) {
        btnSelected(btn: btnVoice)
        btnUnSelected(btn: btnText)
        self.SelectedbtnText = false
        appdelegate.selectedIndex = 99999
        if self.arridVoiceInstruction.count > 0
        {
            lblNoData.isHidden = true
        }else{
            lblNoData.isHidden = false
        }
        self.tblInstruction.reloadData()
    }
    
    func btnUnSelected(btn:UIButton) {
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 15
        btn.setTitleColor(UIColor.black, for: .normal)
    }
    
    func btnSelected(btn:UIButton){
        btn.backgroundColor = UIColor.kbtnAgeSetup()
        btn.layer.borderWidth = 0
        btn.layer.cornerRadius = 15
        btn.setTitleColor(UIColor.white, for: .normal)
    }
    
    @objc func More(sender: UIButton!) {
        showAlert(title: "", message: self.arrInstruction[sender.tag])
        print(self.arrInstruction[sender.tag])
    }
    
    //MARK: - tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.SelectedbtnText) ? self.arrInstruction.count : self.arridVoiceInstruction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InstructionCell") as! InstructionCell

        if SelectedbtnText
        {
            cell.lblText.text = self.arrInstruction[indexPath.row]
            if isFromStudent
            {
                cell.lblText.numberOfLines = 2
                if cell.lblText.maxNumberOfLines > 2
                {
                    cell.btnMore.tag = indexPath.row
                    cell.btnMore.addTarget(self, action: #selector(More(sender:)), for: .touchUpInside)
                    cell.btnMore.isHidden = false
                    cell.btnWidth.constant = 70
                }else{
                    cell.btnMore.isHidden = true
                    cell.btnWidth.constant = 0
                }
            }else{
                cell.btnMore.isHidden = true
                cell.btnWidth.constant = 0
            }
        }else{
            cell.lblText.text = "Recording \(arridVoiceInstruction[indexPath.row])"
            cell.btnMore.isHidden = true
            cell.btnWidth.constant = 0
        }
        if appdelegate.selectedIndex == indexPath.row{
            cell.imgPlay.image = UIImage(named: "Icon_Audio_Play")
        }
        else{
            cell.imgPlay.image = UIImage(named: "Icon_Audio")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if SelectedbtnText{
            let utterance = AVSpeechUtterance(string: self.arrInstruction[indexPath.row])
            utterance.voice = AVSpeechSynthesisVoice(language: "en-AU") //en-IN
            utterance.pitchMultiplier = 1.2
            utterance.rate   = 0.5
            synthesizer.stopSpeaking(at: .immediate)
            MusicPlayer.instance.pause()
            NotificationCenter.default.post(name: Notification.Name("NotificationPlay"), object: nil)
            synthesizer.speak(utterance)
            appdelegate.btnSelectedVoice = false
            appdelegate.selectedIndex = indexPath.row
            self.tblInstruction.reloadData()
        }else{
            synthesizer.stopSpeaking(at: .immediate)
            appdelegate.btnSelectedVoice = true
            appdelegate.selectedIndex = indexPath.row
            if isFromStudent == false{
                MusicPlayer.instance.initPlayer(url: URL(string: arrvoiceInstruction[indexPath.row])!)
            }else{
            let path = getDirectory().appendingPathComponent("\(arridVoiceInstruction[indexPath.row]).m4a")
            print("Path of URL", path)
            do
            {
                print(path)
//                audioPlayer = try AVAudioPlayer(contentsOf: path)
//                audioPlayer.play()
                MusicPlayer.instance.initPlayer(url: path)
            }catch
            {
                
            }
            }
            self.tblInstruction.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    //MARK: - AVSpeechSynthesizerDelegate
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        appdelegate.selectedIndex = 99999
        print("all done")
        NotificationCenter.default.post(name: Notification.Name("NotificationOver"), object: nil)
        self.tblInstruction.reloadData()
    }
}


//MARK: - Instruction Cell
class InstructionCell : UITableViewCell{
    
    //MARK: - Local
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var imgPlay: UIImageView!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var btnWidth: NSLayoutConstraint!
    
}
extension UILabel {
    var maxNumberOfLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let text = (self.text ?? "") as NSString
        let textHeight = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
}
