# 툭 (따라 만들기)

잠금화면 카드(Live Activity)에서 바로 체크하는 초간단 투두 앱.
Mac 없이 GitHub Actions로 빌드하고, Windows에서 무료 Apple ID로 설치한다.

## 지금 들어있는 기능
- 할 일 입력 / 체크 / 스와이프 삭제 / 순서 변경 / 완료 비우기
- 새 할 일을 맨 위 or 맨 아래에 붙이기 (톱니바퀴 메뉴)
- 잠금화면 카드: 최대 5개, 탭하면 바로 체크
- 단축어 "할 일 추가" (앱 안 열고 입력)

## 설치 순서
1. 이 폴더를 GitHub **공개(Public)** 저장소에 올린다 (공개여야 macOS 빌드가 무료).
2. 저장소 → **Actions** 탭 → "Build unsigned IPA" 실행이 끝나면 `Tuk-ipa` 를 내려받아 압축을 푼다 → `Tuk.ipa`.
3. Windows에 **iTunes**(Apple 사이트 버전, MS Store 버전 X)와 **Sideloadly** 설치.
4. 아이폰을 USB로 연결 → Sideloadly에 `Tuk.ipa` 끌어놓기 → Apple ID 입력 → Start.
5. 아이폰: 설정 → 일반 → VPN 및 기기 관리 → 내 Apple ID 신뢰.
6. 설정 → 개인정보 보호 및 보안 → **개발자 모드** 켜기 (재시동).
7. 앱 실행 → 할 일 하나 적으면 잠금화면 카드가 뜬다.

**7일마다** 4번을 다시 해야 한다 (무료 Apple ID 제한). Sideloadly의 자동 갱신을 켜두면 편하다.

## 알려진 한계
- Live Activity는 iOS 규칙상 약 8시간 뒤 꺼진다. 앱을 한 번 열면 다시 뜬다.
- 카드가 꺼진 상태에서 단축어로만 추가하면 카드가 새로 뜨지 않을 수 있다 (백그라운드 시작 제한).
- 홈 화면 위젯, 애플워치, iCloud 동기화는 아직 없음. 위젯은 App Group이 필요해 무료 계정에서 될지 확인 필요.
