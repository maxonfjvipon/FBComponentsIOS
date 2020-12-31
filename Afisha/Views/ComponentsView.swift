//
//  ComponentsView.swift
//  Afisha
//
//  Created by Maxim Trunnikov on 12/4/20.
//

import SwiftUI
import AVFoundation
import AudioToolbox

struct ComponentsView: View {
    @State var torchOn = false
    @State var musicOn = false
    let pattern = [2, 1, 1, 1, 1, 2]
    @State var count = ""
    @State var torchTapped = false
    
    var body: some View {
        VStack {
            Toggle(isOn: $torchOn, label: {
                Text("Фонарик")
                    .font(.title3)
            })
            .frame(width: 150)
            .onReceive([self.torchOn].publisher.first(), perform: { _ in
                if activeTorch() {
                    MusicPlayer.shared.playSoundEffect()
                }
            })
            .padding()
            HStack {
                TextField("Кол-во", text: $count)
                    .font(.title3)
                    .autocapitalization(.none)
                    .frame(width: 80)
                Button(action: {
                    if Int(count) ?? 1 > 10 {
                        count = "10"
                    }
                    for _ in 0..<(Int(count) ?? 1) {
                        vibrate()
                        sleep(1)
                    }
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.yellow)
                            .frame(width: 100, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Text("Вибрация")
                            .foregroundColor(.black)
                    }
                }
            }.frame(width: 250)
            .padding()
            Button(action: {
                for i in 0..<pattern.count {
                    vibrate()
                    sleep(UInt32(pattern[i]))
                }
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.yellow)
                        .frame(width: 200, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Text("Вибрация по паттерну")
                        .foregroundColor(.black)
                }
            }
            .frame(width: 250)
            .padding()
            Toggle(isOn: $musicOn, label: {
                Text("Музыка")
                    .font(.title3)
            })
            .frame(width: 150)
            .onReceive([self.musicOn].publisher.first(), perform: { _ in
                activeMusic()
            })
            .padding()
            .navigationBarTitle(Text("Компоненты"))
        }
    }
    
    func activeMusic() {
        if musicOn {
            MusicPlayer.shared.startBackgroundMusic()
        } else {
            MusicPlayer.shared.stopBackgroundMusic()
        }
    }
    
    func activeTorch() -> Bool {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return false }
        guard device.hasTorch else { return false }
        
        do {
            try device.lockForConfiguration()
            torchTapped = device.torchMode == .on ? true : false
            device.torchMode = torchOn ? .on : .off
            device.unlockForConfiguration()
            if (torchTapped && device.torchMode == .off) || (!torchTapped && device.torchMode == .on) {
                return true
            } else {
                return false
            }
        } catch {
            print(error)
        }
        return false
    }
    
    func vibrate() {
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {
            
        }
    }
}

struct ComponentsView_Previews: PreviewProvider {
    static var previews: some View {
        ComponentsView()
    }
}

class MusicPlayer {
    static let shared = MusicPlayer()
    var audioPlayer: AVAudioPlayer?
    
    func startBackgroundMusic() {
        if let bundle = Bundle.main.path(forResource: "taverna", ofType: "mp3") {
            let backgroundMusic = NSURL(fileURLWithPath: bundle)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf:backgroundMusic as URL)
                guard let audioPlayer = audioPlayer else { return }
                audioPlayer.numberOfLoops = -1
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch {
                print(error)
            }
        }
    }
    
    func playSoundEffect() {
        if let bundle = Bundle.main.path(forResource: "sound_effect", ofType: "mp3") {
            let soundEffectUrl = NSURL(fileURLWithPath: bundle)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf:soundEffectUrl as URL)
                guard let audioPlayer = audioPlayer else { return }
                audioPlayer.play()
            } catch {
                print(error)
            }
        }
    }
    
    func stopBackgroundMusic() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.stop()
    }
    
}
