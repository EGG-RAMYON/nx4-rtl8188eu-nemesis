# Release Notes — v1.0.3

> **언어:** 한국어 (기본) · English

## 한국어

### 개요

기존 NX4 RTL8188EU Manual WiFi NEMESIS v1.0.3 패키지를 배포하기 위한 문서입니다. 이 릴리스용 패키지에서는 서비스 동작을 변경하지 않았습니다. 커널 드라이버 소스는 [nx4-rtl8188eu-kmod](https://github.com/EGG-RAMYON/nx4-rtl8188eu-kmod) 저장소에서 관리합니다.

### 배포 파일

| 파일 | 설명 | SHA-256 |
|---|---|---|
| `nx4.rtl8188eu.manual_v1.0.3.zip` | NEMESIS에 설치하는 패키지 ZIP | `f17ee6b56b7db786b13f177e6fc055cb2cfc41a1223e5353cba5d5660fcde671` |
| `NX4_RTL8188EU_NEMESIS_v1.0.3_USB.zip` | 설치 descriptor와 패키지 ZIP을 포함한 USB 루트 번들 | `43d9d18ebe8e0aa500a5a2a8858e3123437b719511697a028504f57fab1eb843` |
| `SHA256SUMS` | 위 두 ZIP의 체크섬 | — |

### 설치

1. USB 설치 번들의 압축을 FAT32 또는 exFAT USB 메모리의 루트에 풉니다.
2. 안쪽의 NEMESIS 패키지 ZIP은 다시 압축 해제하지 않습니다.
3. 차량에서 NEMESIS 설치 안내를 진행합니다.
4. 헤드유닛의 USB 포트는 하나이므로, 설치 USB를 제거한 뒤 Wi-Fi 동글을 연결합니다.

### 검증 결과

별도 실차 드라이버 시험에서 `r8188eu.ko` 적재, USB 어댑터 인식, `wlan0` 생성·활성화, AP 연결, DHCP, 외부 IP 통신, DNS 조회, 무선 ADB 연결이 성공했다고 보고됐습니다. 이 결과는 NEMESIS v1.0.3 서비스의 전체 START 경로가 실차 검증됐다는 뜻은 아닙니다.

v1.0.3 서비스의 STOP에서 최초 Android Auto 상태 복원은 확인됐습니다.

### 알려진 문제 및 미검증 항목

- 서비스 START는 USB Wi-Fi 어댑터 사용을 위해 Android Auto 프로젝션 패키지(`com.google.android.projection.sink`)를 비활성화합니다. 서비스가 실행되는 동안 이 패키지로 Android Auto를 사용할 수 없습니다.
- 프로젝션 패키지를 끈 뒤 Wi-Fi 연결에 성공한 결과가 있으나, 충돌의 내부 원인은 규명되지 않았고 Android Auto와 Wi-Fi 동시 사용은 검증되지 않았습니다.
- 사용 중 동글을 뺐다가 다시 연결하면 Wi-Fi가 복구되지 않고 헤드유닛을 재시작한 뒤 다시 동작한다는 증상이 보고됐습니다. 원인과 서비스·드라이버 중 어느 쪽의 문제인지는 확인되지 않았습니다.
- 서비스 전체 START, 반복 START/STOP, 재연결 자동 복구, 재부팅 후 서비스 상태 복원, 강제 종료·전원 차단 후 복구는 검증되지 않았습니다. 셸 trap은 SIGKILL이나 전원 차단에서 실행되지 않습니다.

### 모듈 출처 및 제한

포함 모듈 `r8188eu.ko`의 SHA-256은 `0365d9267aa5c1d4c587646bbc354e047f51e9f78424dd4e54e2bbb78e342c02`이며 드라이버 저장소의 `v0.1.0-nx4d1-candidate` Release 파일과 일치합니다. 이 일치는 성공적인 실차 네트워크 시험에 사용된 모듈과 동일하다는 증거는 아닙니다. 후보 모듈의 디버그 정보에는 임시 빌드 경로 문자열이 포함되어 있습니다.

서비스 스크립트와 메타데이터는 GPL-2.0-only로 제공됩니다. 모듈의 소스·빌드 자료와 라이선스 정보는 [드라이버 저장소](https://github.com/EGG-RAMYON/nx4-rtl8188eu-kmod)를 확인하세요. NEMESIS 원본 프로젝트는 [xwtk/hmg_nemesis](https://github.com/xwtk/hmg_nemesis)입니다.

## English

### Summary

These notes describe the existing NX4 RTL8188EU Manual WiFi NEMESIS v1.0.3 package. The service behavior was not changed for this package release. Kernel driver source is maintained in [nx4-rtl8188eu-kmod](https://github.com/EGG-RAMYON/nx4-rtl8188eu-kmod).

### Release assets

| File | Description | SHA-256 |
|---|---|---|
| `nx4.rtl8188eu.manual_v1.0.3.zip` | NEMESIS installation package | `f17ee6b56b7db786b13f177e6fc055cb2cfc41a1223e5353cba5d5660fcde671` |
| `NX4_RTL8188EU_NEMESIS_v1.0.3_USB.zip` | USB-root bundle containing the install descriptor and package ZIP | `43d9d18ebe8e0aa500a5a2a8858e3123437b719511697a028504f57fab1eb843` |
| `SHA256SUMS` | Checksums for both ZIP files | — |

### Installation

1. Extract the USB bundle to the root of a FAT32 or exFAT USB drive.
2. Keep the nested NEMESIS package ZIP intact; do not extract it.
3. Follow the NEMESIS installation prompt in the head unit.
4. The head unit has one USB port. Remove the installation drive before connecting the Wi-Fi adapter.

### Validation

Separate vehicle testing of the driver reported successful module loading, adapter recognition, `wlan0` creation and activation, AP association, DHCP, external IP traffic, DNS lookup, and wireless ADB. These results do not establish that the complete NEMESIS v1.0.3 START path was validated in the vehicle.

For v1.0.3, STOP restoring the original Android Auto state was confirmed.

### Known issues and unverified behavior

- On service START, the package disables the Android Auto projection package (`com.google.android.projection.sink`) to use the USB Wi-Fi adapter. Android Auto cannot be used through this package while the service is active.
- Wi-Fi connected after the projection package was disabled in a reported test, but the internal cause of the conflict is unknown. Simultaneous Android Auto and Wi-Fi operation has not been validated.
- A user reported that Wi-Fi does not recover after unplugging and reconnecting the adapter, but works again after restarting the head unit. The cause and whether it belongs to the service or driver have not been established.
- Full service START, repeated START/STOP, automatic recovery after adapter reconnection, service-state recovery after reboot, and recovery after forced termination or power loss remain unverified. Shell traps cannot run after SIGKILL or power loss.

### Module provenance and limits

The included `r8188eu.ko` has SHA-256 `0365d9267aa5c1d4c587646bbc354e047f51e9f78424dd4e54e2bbb78e342c02`, matching the `v0.1.0-nx4d1-candidate` Release asset in the driver repository. This does not prove it is the same module used in the successful live network test. The candidate module's debug information contains a temporary build-tree path string.

The service scripts and metadata are provided under GPL-2.0-only. See the [driver repository](https://github.com/EGG-RAMYON/nx4-rtl8188eu-kmod) for module source, build records, and licensing information. The NEMESIS upstream project is [xwtk/hmg_nemesis](https://github.com/xwtk/hmg_nemesis).
