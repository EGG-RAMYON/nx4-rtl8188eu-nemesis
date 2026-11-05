# NEMESIS용 NX4 RTL8188EU Manual WiFi

현대 투싼 NX4 HEV Gen5W 헤드유닛에서 Realtek RTL8188EU USB Wi-Fi 어댑터를 사용하기 위한 실험용 NEMESIS 서비스 패키지입니다. Wi-Fi 서비스 실행과 Android Auto 프로젝션 패키지 상태를 함께 관리합니다.

**개발 배경:** 국내형 5W 헤드유닛은 내장 무선랜 모듈이 없는 경우가 많아 USB 무선랜 어댑터로 무선 네트워크를 보완하려는 목적으로 시작한 프로젝트입니다.

이 저장소에는 NEMESIS 패키지 스크립트와 패키징 도구가 들어 있습니다. 커널 드라이버 소스 저장소는 아닙니다. 드라이버 소스와 빌드 절차는 [`nx4-rtl8188eu-kmod`](https://github.com/EGG-RAMYON/nx4-rtl8188eu-kmod), NEMESIS 원본 프로젝트는 [`xwtk/hmg_nemesis`](https://github.com/xwtk/hmg_nemesis)에서 관리합니다.

## 대상 환경

- 차종 계열: Hyundai Tucson NX4 HEV, Gen5W
- 헤드유닛: Hyundai Mobis AVNT STD G50 WIDE R6
- Android 4.4.2, 커널 `3.18.24-tcc`, ARMv7
- 패키지가 확인하는 기기 속성: `wp_daudioplus_nx4hev_kr`
- NEMESIS 1.16.7
- 시험 어댑터: ipTIME N150L, RTL8188EU, USB ID `0bda:8179`
- 드라이버 모듈: `r8188eu.ko`; 진단 마커: `NX4D1_20261104`

이 값은 대상 플랫폼·빌드와 어댑터 모델을 나타내며 특정 차량 한 대를 식별하지 않습니다. 명시된 환경 외의 호환성은 보장하지 않습니다.

## 패키지 동작

서비스는 기기 속성과 커널 버전을 확인하고 `com.google.android.projection.sink`의 최초 활성/비활성 상태를 저장합니다. Wi-Fi 서비스가 동작하는 동안 이 패키지의 비활성화를 요청하고, `r8188eu.ko`와 진단 파라미터를 적재합니다. 모듈 마커와 USB ID를 확인한 뒤 `wlan0`가 생성될 때까지 기다리고 인터페이스 활성화를 시도합니다. AP, 비밀번호, DHCP, DNS, 라우팅 설정은 하지 않습니다.

정상 종료 또는 처리 가능한 종료 시그널에서는 EXIT trap이 `bin/restore.sh`를 실행합니다. 이 스크립트는 저장된 최초 상태를 복원하고 복원 성공이 확인된 뒤 active 표시를 제거합니다. 원래 상태가 없거나 유효하지 않으면 임의로 활성화·비활성화하지 않습니다.

## 검증 현황

별도 실차 시험에서 모듈 적재, 어댑터 인식, `wlan0` 생성/활성화, AP 연결, DHCP, 외부 IP 통신, DNS 조회, 무선 ADB가 성공했다고 보고됐습니다. Android Auto 프로젝션을 비활성화한 뒤 Wi-Fi 연결이 성공했으며, 내부 원인은 규명되지 않았습니다.

NEMESIS v1.0.3의 STOP 시 최초 Android Auto 상태 복원은 확인됐습니다. 사용 중 동글을 뺐다가 다시 연결하면 기능이 회복되지 않고, 헤드유닛을 재시작한 뒤 다시 동작한다는 증상이 보고됐습니다. 이 증상의 원인과 서비스·드라이버 중 어느 부분에 해당하는지는 아직 확인되지 않았습니다. 서비스의 전체 START 과정, 반복 START/STOP, 재부팅 후 상태 복원, 강제 종료 복구, Android Auto와 Wi-Fi 동시 사용도 확인되지 않았습니다. [검증 현황](docs/VALIDATION.md)을 참조하세요.

## 후속 수정 과제: Android Auto와 USB 무선랜 동시 사용

현재 서비스는 START 시 Wi-Fi 어댑터를 사용하기 위해 Android Auto 프로젝션 패키지(`com.google.android.projection.sink`)를 비활성화합니다. 따라서 서비스가 실행되는 동안에는 이 패키지로 Android Auto를 사용할 수 없습니다. 실차에서는 프로젝션 패키지를 비활성화한 뒤 Wi-Fi 연결이 성공했지만, 충돌의 내부 원인은 규명되지 않았고 두 기능의 동시 사용도 검증되지 않았습니다.

국내형 5W 헤드유닛에 무선랜 기능을 보완하려는 개발 목적에 맞게, Android Auto와 USB 무선랜을 함께 사용할 수 있도록 서비스의 충돌 처리와 자원 조정 방식을 후속 개발자가 조사·수정해야 하는 과제로 남깁니다.

### USB 동글 재연결 후 복구 과제

동글을 뺐다가 다시 연결하면 기능이 돌아오지 않고 헤드유닛 재시작 후 회복된다는 사용 중 증상도 보고됐습니다. 원인과 재현 조건은 아직 분리·검증되지 않았습니다. 서비스나 드라이버가 USB 재연결을 감지해 안전하게 복구하도록 조사·수정하는 일을 후속 과제로 남깁니다.

## 설치

GitHub Release에서 USB 설치 번들을 내려받아 FAT32 또는 exFAT USB 메모리의 **루트**에 압축 해제합니다. 내부 NEMESIS 패키지 ZIP은 다시 풀지 않습니다. USB 루트의 descriptor는 `packages/nx4.rtl8188eu.manual_v1.0.3.zip`을 `type=install` 및 상대 `path`로 지정합니다. 패키지 ZIP 내부에는 별도의 루트 `NEMESIS.data`와 서비스 파일이 있습니다.

헤드유닛의 USB 포트가 하나이므로 설치 USB를 제거한 후 Wi-Fi 동글을 연결하세요. 자세한 절차는 [INSTALL.md](docs/INSTALL.md)를, 관리자의 패키지 재현 절차는 [BUILD.md](docs/BUILD.md)를 참조하세요.

## 서비스 시작·정지 및 제거

NEMESIS Manager 또는 CLI를 이용합니다.

```sh
/system/xbin/nemesis service start nx4.rtl8188eu.manual/wifi-loader
/system/xbin/nemesis service stop nx4.rtl8188eu.manual/wifi-loader
/system/xbin/nemesis uninstall nx4.rtl8188eu.manual
```

실제 head unit의 NEMESIS 버전에서 명령을 확인하세요. 서비스가 동작하는 동안 Android Auto 상태를 수동으로 바꾸지 마세요. 자세한 설명은 [OPERATION.md](docs/OPERATION.md)에 있습니다.

## 복구 및 제한사항

SIGKILL, 전원 차단, 시스템 충돌에서는 셸 trap이 실행되지 않습니다. 서비스 중단 후 문제가 있으면 저장된 상태를 이용해 검토된 복원 도구를 실행한 뒤 제거하세요. 현재 상태만 보고 최초 상태를 추정하지 마세요. Android Auto와 Wi-Fi 동시 사용은 검증되지 않았습니다. [SAFETY.md](docs/SAFETY.md)와 [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)를 참조하세요.

## 출처 및 라이선스

이 저장소의 서비스 스크립트와 메타데이터는 GPL-2.0-only로 배포합니다. [LICENSE](LICENSE)와 [NOTICE.md](NOTICE.md)를 확인하세요. RTL8188EU 모듈은 별도 Release 자산이며 자체 라이선스가 적용됩니다. 소스와 빌드 기록은 드라이버 저장소에 있습니다. NEMESIS는 AGPL-3.0 라이선스의 별도 upstream 프로젝트이며, 구현 코드를 이 저장소에 복사하지 않았습니다.
