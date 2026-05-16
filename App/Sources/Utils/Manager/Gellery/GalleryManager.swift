//
//  GalleryManager.swift
//
//  Created by Jae hyung Kim on 2/15/25.
//

import SwiftUI
import PhotosUI
import SwiftImageCompressor
import UniformTypeIdentifiers

@MainActor
public final class GalleryManager {
    
    private let allowedExtensions: Set<String> = ["jpeg", "jpg", "png"]
    private let allowedVideoExtensions: Set<String> = ["mov", "mp4", "m4v"]

    public enum PickedMedia {
        case image(UIImage)
        case video(URL)
    }
    
    public enum GalleryManagerError: Error {
        case loadError
        case videoLoadError
        case noAccept
        
        var message: String {
            switch self {
            case .loadError:
                return "이미지 불러오는중 문제가 발생했습니다."
            case .videoLoadError:
                return "영상 불러오는중 문제가 발생했습니다."
                
            case .noAccept:
                return "지원하지 않는 파일 형식입니다"
            }
        }
    }
    
    
    /// 이미지를 지정된 크기 제한 내에서 비동기 압축하는 함수
    /// - Parameters:
    ///   - image: 압축할 `UIImage`
    ///   - zipRate: 최대 허용 크기 (MB 단위)
    /// - Returns: 압축된 `Data` 또는 실패 시 `nil`
    public func compressImageAsync(_ image: UIImage, zipRate: Double) async -> Data? {
        return await image.reSizeWithCompressImage(type: .jpeg, targetMB: zipRate)
    }

    public func checkImageMimeType(item: PhotosPickerItem) async -> Result<UIImage, GalleryManagerError> {
        do {
            guard let imageData = try await item.loadTransferable(type: Data.self),
                  let image = UIImage(data: imageData) else {
                return .failure(.loadError)
            }
            
            guard let uti = item.supportedContentTypes.first?.identifier else  {
                return .failure(.loadError)
            }
            
            let fileExtension = getFileExtension(from: uti)
            
            // ✅ 허용된 확장자인 경우만 저장
            if allowedExtensions.contains(fileExtension) {
                return .success(image)
            }
            // ❌ 허용되지 않은 확장자 -> 무시 (또는 경고 메시지 추가 가능)
            else {
                return .failure(.noAccept)
            }
        } catch {
            return .failure(.loadError)
        }
    }

    public func checkMediaType(item: PhotosPickerItem) async -> Result<PickedMedia, GalleryManagerError> {
        guard let contentType = item.supportedContentTypes.first else {
            return .failure(.loadError)
        }

        let fileExtension = getFileExtension(from: contentType.identifier)

        if contentType.conforms(to: .image), allowedExtensions.contains(fileExtension) {
            do {
                guard let imageData = try await item.loadTransferable(type: Data.self),
                      let image = UIImage(data: imageData) else {
                    return .failure(.loadError)
                }

                return .success(.image(image))
            } catch {
                return .failure(.loadError)
            }
        }

        if contentType.conforms(to: .movie), allowedVideoExtensions.contains(fileExtension) {
            do {
                if let videoURL = try await item.loadTransferable(type: URL.self) {
                    return .success(.video(videoURL))
                }

                guard let videoData = try await item.loadTransferable(type: Data.self) else {
                    return .failure(.videoLoadError)
                }

                let temporaryURL = try makeTemporaryVideoURL(with: fileExtension)
                try videoData.write(to: temporaryURL, options: .atomic)
                return .success(.video(temporaryURL))
            } catch {
                return .failure(.videoLoadError)
            }
        }

        return .failure(.noAccept)
    }
    
    private func getFileExtension(from uti: String) -> String {
        if uti.contains("jpeg") { return "jpeg" }
        if uti.contains("jpg") { return "jpg" }
        if uti.contains("png") { return "png" }
        if uti.contains("quicktime") { return "mov" }
        if uti.contains("mpeg4") || uti.contains("mp4") { return "mp4" }
        if uti.contains("m4v") { return "m4v" }
        return "unknown"
    }

    private func makeTemporaryVideoURL(with fileExtension: String) throws -> URL {
        let tempDirectory = FileManager.default.temporaryDirectory
        let tempFileName = UUID().uuidString
        let resolvedExtension = fileExtension == "unknown" ? "mov" : fileExtension
        return tempDirectory.appendingPathComponent(tempFileName).appendingPathExtension(resolvedExtension)
    }
    
    init() {
        print("ImageManager")
    }
}

extension GalleryManager: @preconcurrency EnvironmentKey {
    public static let defaultValue: GalleryManager = GalleryManager()
}

extension EnvironmentValues {
    public var galleryManager: GalleryManager {
        get { self[GalleryManager.self] }
        set { self[GalleryManager.self] = newValue }
    }
}
