<a href="https://recognito.vision" style="display: flex; align-items: center;">
    <img src="https://github.com/recognito-vision/Linux-FaceRecognition-FaceLivenessDetection/assets/153883841/b82f5c35-09d0-4064-a252-4bcd14e22407" alt="recognito.vision"/>
</a><br/>

# Face Recognition, Liveness Detection, Pose Estimation Flutter SDK Demo
<p align="center">
    <img alt="nist frvt top1" src="https://recognito.vision/wp-content/uploads/2024/03/NIST.png" width=90%/>
</p>
<p align="center" style="font-size: 24px; font-weight: bold;">
    <a href="https://pages.nist.gov/frvt/html/frvt11.html" target="_blank">
        Latest NIST FRVT Report
    </a>  
</p>

### <img src="https://github.com/user-attachments/assets/59da5e7c-9a2e-40c4-821b-5b1e05fb905b" alt="home" width="30"> _Recognito Developer News_
- Global Coverage [**ID Card/Passport OCR Mobile Demo**](https://github.com/recognito-vision/Android-ID-Document-Recognition/tree/main) and [**ID Document Recognition Server Demo**](https://github.com/recognito-vision/Linux-ID-Document-Recognition).
- Try **1:N Face Search** through our [**Face Identification Web Demo**](https://github.com/recognito-vision/Linux-FaceRecognition-FaceLivenessDetection/tree/main/Identification(1%3AN)-Demo).
- Subscribe our **Free APIs** for your app or website from our [**API Hub**](https://rapidapi.com/organization/recognito).
<!--- Clone our [**Hugging Face space**](https://huggingface.co/recognito) for your IDV project setup.-->
<br/>

This repository contains a demonstration of Recognito's face recognition SDK for Flutter. 
The SDK includes advanced features such as face recognition, liveness detection, and pose estimation. 
Recognito's face recognition algorithm has been ranked as the **Top 1 in the NIST FRVT** (Face Recognition Vendor Test).

Our [**Product List**](https://github.com/recognito-vision/Product-List/) for ID verification.

## <img src="https://github.com/recognito-vision/.github/assets/153883841/dc7c1c3f-8269-475c-a689-cb57be36a920" alt="home" width="25">   RECOGNITO Product Documentation
&emsp;&emsp;<a href="https://docs.recognito.vision" style="display: flex; align-items: center;"><img src="https://recognito.vision/wp-content/uploads/2024/05/book.png" style="width: 64px; margin-right: 5px;"/></a>

## <img src="https://github.com/recognito-vision/Linux-FaceRecognition-FaceLivenessDetection/assets/153883841/d0991c83-44f0-4d38-bcc8-74376ce93ded" alt="feature" width="25">  Features
- **Face Recognition:** Identify and verify individuals by comparing their facial features.
- **Liveness Detection:** Determine whether a face is live or spoofed to prevent fraud in authentication processes.
- **Pose Estimation:** Estimate the pose of a detected face, including Yaw, Roll, Pitch

### - Additional Features
- **NIST FRVT Top 1 Algorithm:** Utilize the top-ranked face recognition algorithm from the NIST FRVT for accurate and reliable results.
- **On-premise:** Operate entirely within your infrastructure, ensuring data privacy and security.
- **Real-time:** Perform face recognition, liveness detection, and pose estimation with minimal latency.
- **Fully-offline:** Function without the need for an internet connection, ensuring reliability and data privacy.

## <img src="https://github.com/recognito-vision/Android-FaceRecognition-FaceLivenessDetection/assets/153883841/6d34f50e-df5a-4d2a-8ce6-a38b8203d3e6" alt="youtube" width="25">  Demo Video
[<img src="https://github.com/recognito-vision/Android-FaceRecognition-FaceLivenessDetection/assets/153883841/d17ee602-31a9-43e4-8d00-869e7456b2de" width="70%">](https://www.youtube.com/watch?v=9HM70PFa4lQ)

Recognito Youtube Channel:   [youtube.com/@recognito-vision](https://www.youtube.com/@recognito-vision)
<p align="center">
  <img src="https://github.com/recognito-vision/Android-FaceRecognition-FaceLivenessDetection/assets/153883841/9d5813c0-2f9e-4ab5-a70a-38d8967c5b99" alt="face recognition, liveness detection android demo snap 1" width="16%" />
  <img src="https://github.com/recognito-vision/Android-FaceRecognition-FaceLivenessDetection/assets/153883841/e7dab27d-5d41-4f66-8cdb-1978c53a8b87" alt="face recognition, liveness detection android demo snap 2" width="16%" />
  <img src="https://github.com/recognito-vision/Android-FaceRecognition-FaceLivenessDetection/assets/153883841/700e1627-9b90-4354-923a-8dcc2536e9f0" alt="face recognition, liveness detection android demo snap 3" width="16%" />
  <img src="https://github.com/recognito-vision/Android-FaceRecognition-FaceLivenessDetection/assets/153883841/0466d171-4a38-4fd4-ab27-33931711febc" alt="face recognition, liveness detection android demo snap 4" width="16%" />
  <img src="https://github.com/recognito-vision/Android-FaceRecognition-FaceLivenessDetection/assets/153883841/02eef939-6b3f-4f68-a4cc-c116e0494fa8" alt="face recognition, liveness detection android demo snap 5" width="16%" />
  <img src="https://github.com/recognito-vision/Android-FaceRecognition-FaceLivenessDetection/assets/153883841/d2f70698-932d-4bf0-900f-7f432b8702b7" alt="face recognition, liveness detection android demo snap 6" width="16%" />
</p>

## <img src="https://github.com/recognito-vision/Android-FaceRecognition-FaceLivenessDetection/assets/153883841/05f9ac6c-1224-46a9-8c74-04b8f8cfe5ab" alt="face recognition, liveness detection android SDK API" width="25">  SDK Integration
To use the Recognito SDK in your Flutter project, follow these steps:
#### 1. `FaceSDK Plugin` Setup
- Add `facesdk_plugin` package to dependencies in `pubspec.yaml` file.
  ![pubspec](https://github.com/user-attachments/assets/f6ab3bc0-9f1f-4724-8226-1ad3c12665ea)

- Import `facesdk_plugin` package in dart files.
  ![import_facesdkplugin](https://github.com/user-attachments/assets/cdf5691a-8ef1-47cd-ae44-5b046f007e27)

#### 2. Android, iOS Setup
- Add `libfacesdk` to `settings.gradle` in `android` folder.
  ![android_setting](https://github.com/user-attachments/assets/8195f800-0d29-488c-9a63-ef54e0272274)

- iOS SDK `facesdk.framework` is already included in the `facesdk_plugin` package, so you don't need to download and import it into your project.

#### 3. Project Setup
- For project setup, run the following commands:
  `flutter pub get`

#### 4. Application License (One-Time License)
- For trial license, share your application ID and bundle ID
  
  <div style="display: flex; align-items: center;">
    <a target="_blank" href="mailto:hassan@recognito.vision"><img src="https://img.shields.io/badge/email-hassan@recognito.vision-blue.svg?logo=gmail " alt="www.recognito.vision"></a>
    &nbsp;&nbsp;&nbsp;&nbsp;<a target="_blank" href="https://wa.me/+14158003112"><img src="https://img.shields.io/badge/whatsapp-+14158003112-blue.svg?logo=whatsapp " alt="www.recognito.vision"></a>
    &nbsp;&nbsp;&nbsp;&nbsp;<a target="_blank" href="https://t.me/recognito_vision"><img src="https://img.shields.io/badge/telegram-@recognito__vision-blue.svg?logo=telegram " alt="www.recognito.vision"></a>
    &nbsp;&nbsp;&nbsp;&nbsp;<a target="_blank" href="https://join.slack.com/t/recognito-workspace/shared_invite/zt-2d4kscqgn-"><img src="https://img.shields.io/badge/slack-recognito__workspace-blue.svg?logo=slack " alt="www.recognito.vision"></a>
  </div>

- Initialize SDK with license.
  ```dart
    try {
    if (Platform.isAndroid) {
      await _facesdkPlugin
          .setActivation(
              "EO5wcxhdMXJoLRpKq3Lexv2sTHPU8Ehed3vsBwmzdye/MJw+rVJTnY9SidD3vKV/2YNE6kufwIcC"
              "7LvLGFSORk3b14swPe7415aYSLKNI2RaUL5Nfn9oWHBjW1XehQLjLUx3w0Qi8bUth6vyg9Oaj7V7"
              "+dKruxjx/2dD2ddXKBoiIwYDonjW7gx7PmF9W66DXDtfRGpARvKW5Cn+jSCCH8A3Gft8wOBdQXM8"
              "UTDZUZxNbvozkgV6Dw9hMQJSka06iFK1h/UO6NrGLudt1SOC2b3hfoFJcAVjl3W7UTxzVyByJpLp"
              "tYTWJNr36pn1ixWhazLHC4s4TXtyQR67yzN3aw==")
          .then((value) => facepluginState = value ?? -1);
    } else {
      await _facesdkPlugin
          .setActivation(
              "H/Fs6Zgbsi9av6VVDAi54yqpYxnq0eDV3MSZAxMnARvUVePNY85UJu3d95nM7iO2RrCm19/eq+qb"
              "gSDmhJRYVJBMEUcxG+0cPPWVAW7m46dfS1Kpn+Flqbanfbco+Hd9Uda3aAzDkklzgdfYt7TvSXRt"
              "LZ8wW7jLiPjt8Lufj1GvhRzfESARv18VrxfQV+U8x3EqqvfKTJrkkg91NuAKvUZSoao4B5pQLpRd"
              "GwQ/saP9AQSWuyU1Zw+Whw/cnmXY2xZLGx6n/ict3NW9vpttv2tBbPCe/TdofRuJbE7R1Yb60BvQ"
              "ajzoaQWx3RsRgca9ah+Pccxb15tPVzr1apTK7A==")
          .then((value) => facepluginState = value ?? -1);
    }
  
    if (facepluginState == 0) {
      await _facesdkPlugin
          .init()
          .then((value) => facepluginState = value ?? -1);
    }
  } catch (e) {}
  ```

  Initialization status codes:
  
  | Code | Status |
  |:------:|------|
  |0|Activate SDK successfully|
  |-1|License Key Error|
  |-2|License AppID Error|
  |-3|License Expired|
  |-4|Activate Error|
  |-5|Init SDK Error|


## <img src="https://github.com/recognito-vision/Linux-FaceRecognition-FaceLivenessDetection/assets/153883841/78c5efee-15f3-4406-ab4d-13fd1182d20c" alt="contact" width="25">  Support
For any questions, issues, or feature requests, please contact our support team.

<div style="display: flex; align-items: center;">
    <a target="_blank" href="mailto:hassan@recognito.vision"><img src="https://img.shields.io/badge/email-hassan@recognito.vision-blue.svg?logo=gmail " alt="www.recognito.vision"></a>
    &nbsp;&nbsp;&nbsp;&nbsp;<a target="_blank" href="https://wa.me/+14158003112"><img src="https://img.shields.io/badge/whatsapp-+14158003112-blue.svg?logo=whatsapp " alt="www.recognito.vision"></a>
    &nbsp;&nbsp;&nbsp;&nbsp;<a target="_blank" href="https://t.me/recognito_vision"><img src="https://img.shields.io/badge/telegram-@recognito__vision-blue.svg?logo=telegram " alt="www.recognito.vision"></a>
    &nbsp;&nbsp;&nbsp;&nbsp;<a target="_blank" href="https://join.slack.com/t/recognito-workspace/shared_invite/zt-2d4kscqgn-"><img src="https://img.shields.io/badge/slack-recognito__workspace-blue.svg?logo=slack " alt="www.recognito.vision"></a>
</div>
<br/>
<p align="center">
    &emsp;&emsp;<a href="https://recognito.vision" style="display: flex; align-items: center;"><img src="https://recognito.vision/wp-content/uploads/2024/03/recognito_64_cl.png" style="width: 32px; margin-right: 5px;"/></a>
    &nbsp;&nbsp;&nbsp;&nbsp;<a href="https://www.linkedin.com/company/recognito-vision" style="display: flex; align-items: center;"><img src="https://recognito.vision/wp-content/uploads/2024/03/linkedin_64_cl.png" style="width: 32px; margin-right: 5px;"/></a>
    &nbsp;&nbsp;&nbsp;&nbsp;<a href="https://huggingface.co/recognito" style="display: flex; align-items: center;"><img src="https://recognito.vision/wp-content/uploads/2024/03/hf_64_cl.png" style="width: 32px; margin-right: 5px;"/></a>
    &nbsp;&nbsp;&nbsp;&nbsp;<a href="https://github.com/recognito-vision" style="display: flex; align-items: center;"><img src="https://recognito.vision/wp-content/uploads/2024/03/github_64_cl.png" style="width: 32px; margin-right: 5px;"/></a>
    &nbsp;&nbsp;&nbsp;&nbsp;<a href="https://hub.docker.com/u/recognito" style="display: flex; align-items: center;"><img src="https://recognito.vision/wp-content/uploads/2024/03/docker_64_cl.png" style="width: 32px; margin-right: 5px;"/></a>
    &nbsp;&nbsp;&nbsp;&nbsp;<a href="https://www.youtube.com/@recognito-vision" style="display: flex; align-items: center;"><img src="https://recognito.vision/wp-content/uploads/2024/04/youtube_64_cl.png" style="width: 32px; margin-right: 5px;"/></a>
</p>

