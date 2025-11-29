import Flutter
import UIKit
import EbsSDKAdapter // Импортируем наш фреймворк

public class SwiftEbPlugin: NSObject, FlutterPlugin, NativeHostApiProtocol {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "ebs_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftEbPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    NativeHostApiSetup.setUp(binaryMessenger: registrar.messenger(), api: instance)
  }

  public func isInstalledApp(completion: @escaping (Bool) -> Void) {
    completion(EbsSDKClient.shared.ebsAppIsInstalled())
  }

  public func getAppName(completion: @escaping (String) -> Void) {
    // EbsSDKClient не предоставляет метод для получения названия, возвращаем константу
    completion("Госуслуги Биометрия")
  }

  public func getRequestInstallAppText(completion: @escaping (String) -> Void) {
    // EbsSDKClient не предоставляет метод для получения текста запроса, возвращаем константу
    completion("Пожалуйста, установите приложение 'Госуслуги Биометрия' для продолжения")
  }

  public func requestInstallApp(completion: @escaping (Bool) -> Void) {
    let success = EbsSDKClient.shared.openEbsInAppStore()
    completion(success)
  }

  public func requestVerification(infoSystem: String, adapterUri: String, sid: String, dboKoUri: String, dbkKoPublicUri: String, completion: @escaping (EbsResultData) -> Void) {
    // Инициализируем SDK
    EbsSDKClient.shared.set(scheme: "your_app_scheme", title: "Your App Title", infoSystem: infoSystem) // Замените на реальные значения

    let sessionDetails = EbsSessionDetails( /* ... инициализируйте сюда sid, adapterUri, dboKoUri, dbkKoPublicUri ... */ )
    // Создаем sessionDetails. Точный способ зависит от API EbsSDKClient.
    // Возможно, EbsSessionDetails не принимает все параметры напрямую.
    // Нужно смотреть документацию.

    EbsSDKClient.shared.requestEbsVerification(sessionDetails: sessionDetails) { result in
      switch result {
      case .success(let verificationDetails):
        let resData = NativeHostApiEbsResultDataBuilder()
          .setIsError(false)
          .setSecret(verificationDetails.resSecret) // Предполагаем, что verificationDetails содержит resSecret
          .setErrorString(nil)
          .build()
        completion(resData)
      case .cancel:
        let resData = NativeHostApiEbsResultDataBuilder()
          .setIsError(true)
          .setSecret(nil)
          .setErrorString("Верификация отменена")
          .build()
        completion(resData)
      case .failure(let error):
        let resData = NativeHostApiEbsResultDataBuilder()
          .setIsError(true)
          .setSecret(nil)
          .setErrorString(error.localizedDescription)
          .build()
        completion(resData)
      }
    }
  }
}