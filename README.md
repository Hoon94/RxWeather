# 🌡 RxWeather

## 📖 목차
1. [소개](#-소개)
2. [시각화된 프로젝트 구조](#-시각화된-프로젝트-구조)
3. [실행 화면](#-실행-화면)
4. [트러블 슈팅](#-트러블-슈팅)
5. [참고 링크](#-참고-링크)

</br>

## 🍀 소개
RxSwift6를 활용하여 위치 정보에 따른 날씨를 표시합니다.

* 주요 개념: `RxSwift`, `CLLocation`, `Networking`

</br>

## 👀 시각화된 프로젝트 구조

```
📦 TwitterTutorial
 ┣ 📂App
 ┣ 📂Scene
 ┣ 📂Service
 ┃ ┗ 📂Locations
 ┣ 📂Model
 ┣ 📂ViewController
 ┃ ┗ 📂Cell
 ┣ 📂ViewModel
 ┗ 📂Extension
```

### 📚 Architecture ∙ Framework ∙ Library

| Category| Name | Tag |
| ---| --- | --- |
| Architecture| MVVM |  |
| Framework| UIKit | UI |
|Library | RxSwift | Data Binding |
| | SnapKit | Layout |

</br>

## 💻 실행 화면 

| 날씨 정보 | 위치 변경 |
|:--------:|:--------:|
|<img src="https://github.com/user-attachments/assets/e68136cb-4e60-44b9-a79d-17fd0eeffb92" width="250">|<img src="https://github.com/user-attachments/assets/e69dae7b-a9fe-4fc7-b0f8-0f9d260229b8" width="250">|

</br>

## 🧨 트러블 슈팅

1️⃣ **iOS 시뮬레이터 GPX를 통한 위치 변경 테스트** <br>
-
🔒 **문제점** <br>
- 위치 정보에 따른 날씨 정보를 받아오는 API를 사용하였습니다. 하지만 iOS 시뮬레이터 기기에서 위치 변경을 하는 과정에서 직접 위치에 대한 좌표를 입력해주어야 하는 문제점이 있었습니다. 

🔑 **해결방법** <br>
- 이를 해결하기 위해 GPX를 사용하였습니다. GPX는 XML 형식으로 시간별 위치 정보를 담고 있는 파일입니다. 이 파일을 사용해 iOS 시뮬레이터에서 미리 설정한 GPX 파일의 위치로 변경하며, 변경된 위치 정보를 기반으로 날씨 정보를 불러오는 API를 다시 실행할 수 있었습니다.

<br>

2️⃣ **UITableView Inset 설정** <br>
-
🔒 **문제점** <br>
- TableView의 시작 위치를 다음과 같이 지정하였습니다.

    ```swift
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if topInset == 0.0 {
            let first = IndexPath(row: 0, section: 0)
            
            if let cell = listTableView.cellForRow(at: first) {
                topInset = listTableView.frame.height - cell.frame.height
                listTableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
            }
        }
    }
    ```
    
    하지만 초기 뷰가 나타나는 과정에서 cell에 대한 정보가 nil로 나와 첫 화면에서 위와 같은 inset 설정이 적용되지 않는 문제점이 있었습니다.

🔑 **해결방법** <br>


<br>

3️⃣ **Coordinator Pattern을 통한 화면 전환** <br>
-
🔒 **문제점** <br>
- 화면 전환 역할을 ViewController에서 담당하고 있었습니다. 하지만 이런 경우 현재 ViewController에서 다음으로 실행할 ViewController를 알아야 한다는 점 때문에 높은 결합도를 가질 수 밖에 없었습니다. 또한 프로젝트의 규모가 커질수록 ViewController에서 담당해야 하는 역할이 많아진다는 단점이 있었습니다.

🔑 **해결방법** <br>
- 이를 해결하기 위해 화면 전환 역할을 분리하도록 다음과 같은 과정을 진행하였습니다. 

    - 전환과 관련된 열거형 추가 (TransitionModel.swift)

        ```swift
        enum TransitionStyle {
            case root
            case push
            case modal
        }
        ```
    
    - 앱에서 구현할 scene을 열거형으로 선언 (Scene.swift)

        ```swift
        enum Scene {
            case list(ListViewModel)
            case detail(DetailViewModel)
            case compose(ComposeViewModel)
        }
        ```        

    - Scene과 전환 방식을 매개변수로 받아 다음 Scene으로 전환하는 메서드 추가 (SceneCoordinator.swift)

        ```swift
        protocol SceneCoordinatorType {
            @discardableResult
            func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable

            @discardableResult
            func close(animated: Bool) -> Completable
        }
        ```

    SceneCoordinator는 화면전환을 처리하기 때문에 윈도우 인스턴스와 현재화면에 표시되어 있는 신을 가지고 있어야 합니다.
    
    위와 같이 환면 전환 역할을 SceneCoordinator로 양도하였습니다. 실제로 viewController에서 화면을 전환하는 경우 다음 화면에 필요한 객체를 매개변수로 주입해주는 형태로 화면 전환을 진행할 수 있었습니다.


</br>

## 📚 참고 링크
- [📘blog: iOS 시뮬레이터 GPX를 통한 위치 변경 테스트](https://krpeppermint100.medium.com/ios-%EC%8B%9C%EB%AE%AC%EB%A0%88%EC%9D%B4%ED%84%B0-gpx%EB%A5%BC-%ED%86%B5%ED%95%9C-%EC%9C%84%EC%B9%98-%EB%B3%80%EA%B2%BD-%ED%85%8C%EC%8A%A4%ED%8A%B8-85af7038c29a)
</br>
