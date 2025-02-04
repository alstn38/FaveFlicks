# FaveFlicks

🎬 **FaveFlicks**는 현재 영화 트렌드 TOP10을 확인하고, 

원하는 영화를 검색하여 상세 정보를 얻을 수 있는 앱입니다.

좋아하는 영화를 '좋아요'로 저장하고

**FaveFlicks**와 함께 영화 세계를 만들어보세요! 🎥✨




## 주요 기능

### 🎉 **온보딩 및 프로필 설정**

|   온보딩 및 프로필 설정   | 
|  :-------------: |
| <img width=200 src="https://github.com/user-attachments/assets/b540060e-42e5-4c62-abc9-d223f6643e31"> | 

- 프로필 사진과 닉네임을 설정할 수 있습니다.



### 🎬 메인화면

|   메인화면   | 
|  :-------------: |
| <img width=200 src="https://github.com/user-attachments/assets/ba41d083-adce-4948-b138-5773ee18acaa"> | 

- 사용자의 정보를 확인할 수 있습니다.
- 최근 검색어 기능을 제공합니다.
- 현재 영화 트렌드 TOP 10 영화에 대한 정보를 확인할 수 있습니다.



### 🔍 **검색 기능**

|   검색 기능   | 
|  :-------------: |
| <img width=200 src="https://github.com/user-attachments/assets/f071f5ef-14c0-4af0-8781-fa3c5e5eca50"> | 

- 원하는 제목의 영화를 검색할 수 있습니다.
- 검색 키워드는 하이라이트 처리됩니다.



### **👀 최근 검색어 기능**

|   최근 검색어 기능   | 
|  :-------------: |
| <img width=200 src="https://github.com/user-attachments/assets/3ad4c7e1-1d19-4a12-a002-905b481e56d6"> | 

- 검색 기능을 통해 검색한 키워드에 대해서 쉽게 검색할 수 있습니다.
- 최근 검색어는 삭제할 수 있습니다.



### 🎞 **영화 상세 정보**

|   영화 상세 정보   | 
|  :-------------: |
| <img width=200 src="https://github.com/user-attachments/assets/699e1174-b9da-4c3b-9628-7fcc73bed200"> | 

- 영화 이미지, 개봉일, 평점, 장르, 줄거리, 출연진, 포스터 정보를 제공합니다.
- 좋아요 버튼을 눌러 원하는 영화를 저장할 수 있습니다.



### 👤 **프로필 설정**

|   프로필 설정   | 
|  :-------------: |
| <img width=200 src="https://github.com/user-attachments/assets/a9b9bd09-b4d4-4e87-8e2a-1c4b4713f909"> | 

- 프로필 사진과 닉네임을 변경할 수 있습니다.
- 회원 탈퇴 기능이 포함되어 있습니다.
- 기존의 닉네임과 이미지가 표시됩니다.



## 🎯 앱 기술 설명


**싱글톤을 활용한 Alamofire 네트워크 Layer 구축**

네트워크 통신을 요청하는 코드의 중복을 줄이기 위해 `NetworkService` 싱글톤 객체를 만들어서 사용했습니다.

Alamofire는 싱글톤으로 설계되어 있기 때문에 `NetworkService` 또한 싱글톤으로 구현하여 일관성을 유지했습니다.

네트워크를 요청하는 함수는 `제네릭`과 `completionHandler`를 활용하여 구현했습니다.

제네릭은 네트워크 요청을 위한 모델 설계과정에서 `EndPointProtocol`의 프로토콜을 정의하였고, 

해당 타입을 채택하는 네트워크 요청 함수를 통해 Alamofire의 네트워크를 요청을 보다 명확하게 설계했습니다.

또한, CompletionHandler는 모든 네트워크 에러에 대하여 사용자에게 피드백을 주었습니다.

**사용자 정보를 쉽게 저장하기 위한 UserDefault Property Wrapper Model 정의**

온보딩 여부, 닉네임, 프로필 이미지, 가입날짜, 좋아하는 영화 등의 사용자 정보를 저장하는 과정에서 UserDefault를 사용했습니다.

반복적으로 사용되는 연산 프로퍼티를 줄이고, 직관적인 사용을 위하여 `Property Wrapper`를 활용하여 UserDefaults 저장 모델을 설계했습니다.



**성능최적화를 위한 고민**

- `final`, `private` 키워드를 활용한 Dynamic Dispatch 감소시키고 Static Dispatch의 사용을 증가시켰습니다.
- 사용자의 좋아하는 영화 조회 기능을 위해 `Dictionary` 사용하여 탐색 `시간 복잡도를 감소`시켜 데이터 접근 시간을 최소화 했습니다.
- 검색 결과 처리를 위한 20개 검색결과를 기준으로 `pagination` 처리하여 `네트워크 사용량을 감소`시켰습니다.



**사용자 UX 경험 향상을 위한 고민**

- 터치 피드백 적용
    
    내 정보를 표시하는 View를 구현하는 과정에서 클릭이 되는 효과를 부여하기 위해서 터치 피드백을 추가했습니다.
    
    `touchesBegan`, `touchesEnded`, `touchesCancelled` 를 활용하여 적절한 view의 처리를 통해서 누르는 효과를 경험할 수 있습니다.
    
- 이미지를 표시하는 UICollectionViewCell의 경우 이미지가 로드될 때까지 UIActivityIndicatorView를 활용하여 사용자에게 네트워크 상태에 따른 지연을 피드백 주었습니다.
- 검색 결과 화면의 경우 검색한 키워드의 `Highlight`를 통해 사용자가 원하는 결과를 쉽게 찾을 수 있도록 UI를 개선했습니다.
- 네트워크 통신 결과값의 값이 없는 경우 “영화 줄거리 정보가 없습니다”와 같은 기본 메시지와 기본 이미지 대체와 같은 예외 처리를 통해 사용자에게 빈 정보를 제공하지 않도록 했습니다.



**UI에 대한 고민**

- UICollectionView의 `DynamicCell`을 활용하여 최근 검색어 문자의 길이에 상관없이 모든 검색기록이 보이도록 했습니다.
- 화면 비율을 통한 메인화면의 UICollectionView Cell 크기를 설정하여 모든 기기에서 최적의 레이아웃을 유지할 수 있도록 했습니다.




## 🛠 앱 기술 스택

- **Architecture**: MVC
- **UI Framework**: UIKit
- **Data Persistence**: UserDefaults
- **External dependency**: Alamofire, Kingfisher, SnapKit




## 🎯 개발 환경

![iOS](https://img.shields.io/badge/iOS-16%2B-000000?style=for-the-badge&logo=apple&logoColor=white)  
![Swift](https://img.shields.io/badge/Swift-5.9-FA7343?style=for-the-badge&logo=swift&logoColor=white)  
![Xcode](https://img.shields.io/badge/Xcode-16.2-1575F9?style=for-the-badge&logo=Xcode&logoColor=white)  




## 📅 개발 정보

- **개발 기간**: 2025.01.24 ~ 2025.02.01
- **개발인원**: 1명
- **사용한 API**: TMDB API
