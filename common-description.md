요청하신 대로 지금까지 다루었던 핵심 명령어들을 마크다운(Markdown) 형식으로 깔끔하게 정리했습니다.

아래 코드 블록의 우측 상단에 있는 **'복사(Copy)'** 버튼을 누르신 후, 원하시는 텍스트 에디터에 붙여넣고 `openclaw-cheatsheet.md` 등의 이름으로 저장하시면 편하게 두고 보실 수 있습니다!

```markdown
# 🦞 OpenClaw Docker 명령어 치트 시트 (Cheat Sheet)

도커(Docker) 환경에서 OpenClaw 게이트웨이를 운영하고 트러블슈팅할 때 자주 사용하는 핵심 명령어 모음입니다.

---

## 1. 🔄 기본 게이트웨이(컨테이너) 제어
도커 컨테이너를 실행, 중지, 재시작하는 기본 명령어입니다.

* **게이트웨이 백그라운드 실행**
  ```bash
  docker compose up -d openclaw-gateway

```

* **게이트웨이 재시작** (설정 파일 `openclaw.json`이나 `.env` 변경 후 필수)
```bash
docker compose restart openclaw-gateway

```


* **게이트웨이 중지 및 삭제**
```bash
docker compose down

```


* **캐시 무시하고 이미지 강제 재빌드** (업데이트나 심각한 꼬임 현상 해결 시)
```bash
docker compose build --no-cache openclaw-gateway

```



---

## 2. 🔑 토큰 확인 및 대시보드 기기 승인

`1006 abnormal closure`, `1008 device signature expired` 에러 등 네트워크나 인증이 꼬였을 때 해결하는 명령어입니다.

* **`unauthorized: device token mismatch` 에러 발생 시 대시보드 토큰 및 URL 재발급**
  (명령어 실행 후 출력되는 `Token` 값을 대시보드 화면에 입력해 줍니다.)
```bash
docker compose run --rm openclaw-cli dashboard --no-open

```

* **현재 작동 중인 '진짜 토큰' 주소 발급** (대시보드 접속용)
```bash
docker compose exec openclaw-gateway node dist/index.js dashboard --no-open

```


* **승인 대기 중인 기기 목록 및 Request ID 확인**
```bash
docker compose exec openclaw-gateway node dist/index.js devices list

```


* **기기 승인 처리** (`<requestId>` 부분에 위에서 찾은 ID 입력)
```bash
docker compose exec openclaw-gateway node dist/index.js devices approve <requestId>

```



### 🚨 [강제 승인] 토큰 불일치 에러 지속 발생 시

명령어 끝에 토큰을 직접 주입하여 강제로 승인 절차를 통과시킵니다.

```bash
# 1. 토큰 주입하여 기기 목록 확인
docker compose exec openclaw-gateway node dist/index.js devices list --token "발급받은_진짜_토큰"

# 2. 토큰 주입하여 기기 승인
docker compose exec openclaw-gateway node dist/index.js devices approve <requestId> --token "발급받은_진짜_토큰"

```

---

## 3. 🧠 AI 모델 확인 및 변경

`Unknown model` 에러가 뜨거나 기본 모델을 교체할 때 사용합니다.

* **등록된 전체 모델 목록 확인** (Gemini만 필터링)
```bash
docker compose exec openclaw-gateway node dist/index.js models list | grep -i "gemini"

```


* **기본(Primary) 모델 즉시 변경** (예: Gemini 3.1 Pro Preview 모델로 변경)
```bash
docker compose exec openclaw-gateway node dist/index.js models set google/gemini-3.1-pro-preview

```



---

## 4. ⚙️ 환경 설정 및 디버깅

API 키 입력이나 시스템 내부 상태를 점검할 때 유용한 명령어입니다.

* **대화형 설정 마법사 실행** (API 키 입력, 프로바이더 설정, 모델 변경 등)
```bash
docker compose exec openclaw-gateway node dist/index.js configure

```


* **초기 셋업 마법사 다시 실행** (`openclaw.json` 파일이 날아갔을 때 복구용)
```bash
docker compose run --rm openclaw-cli onboard

```


* **도커 내부에 환경변수(API 키 등)가 잘 주입되었는지 확인**
```bash
docker compose exec openclaw-gateway env | grep GEMINI

```


* **도커 컨테이너 내부에 npm 패키지 강제 설치** (예: Gemini CLI 설치)
```bash
docker compose exec -u root openclaw-gateway npm install -g @google/gemini-cli

```



---

> **💡 핵심 요점: `run` vs `exec**`
> * `docker compose run --rm openclaw-cli ...`: 임시로 빈 컨테이너를 새로 띄워서 명령을 실행합니다. (주로 초기 셋업 시 사용)
> * `docker compose exec openclaw-gateway ...`: **현재 켜져 있는 메인 게이트웨이 내부로 들어가서** 명령을 실행합니다. `127.0.0.1` 네트워크 분리 에러를 피하려면 대부분의 트러블슈팅은 `exec`를 사용해야 합니다.
>
>



저장하시다가 혹시 내용에 추가하고 싶은 나만의 트러블슈팅 팁이나, 더 알고 싶은 도커 명령어가 있으신가요? 필요하시다면 시트 내용을 더 보강해 드리겠습니다!
