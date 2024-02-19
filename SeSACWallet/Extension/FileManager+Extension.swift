//
//  FileManager+Extension.swift
//  SeSACWallet
//
//  Created by Madeline on 2/19/24.
//

import UIKit

extension UIViewController {
    func saveImageToDocument(image: UIImage, fileName: String) {
        // 앱의 Document 위치
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        // 이미지 저장할 경로(File Path) 지정("/뒷부분을 지정해주는 것~")
        let fileURL = documentDirectory.appendingPathComponent("\(fileName).jpg")
        
        // 이미지 파일 저장
        // 압축해서 저장 - jpeg
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        do {
            try data.write(to: fileURL)
        } catch {
            print("file save error")
        }
    }
    
    // MARK: Document 폴더에 있는 이미지를 셀에 보여주기
    // Document 위치 찾기 > 경로 완성 > URL 기반으로 조회
    func loadImageFromDocument(fileName: String) -> UIImage? {
        // Document 위치 찾기(desktop/sesac/week9)
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        // 경로 완성(desktop/sesac/week9/1234.jpg)
        let fileURL = documentDirectory.appendingPathComponent("\(fileName).jpg")
        // 경로에 파일이 존재하는지 확인
        // fileURL.path(): string으로 바꿔줌
        if FileManager.default.fileExists(atPath: fileURL.path()) {
            return UIImage(contentsOfFile: fileURL.path())
        } else {
            return UIImage(systemName: "person")
        }
    }
}
