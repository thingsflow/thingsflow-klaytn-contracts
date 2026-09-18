# CI와 배포

## 경계

이 영역은 `.github/workflows/`의 테스트·정적 분석·문서 브랜치·업그레이드 연동과 `netlify.toml`의 사이트 빌드 선언을 소유한다. 계약 구현, 테스트 본문, GitHub 조직 설정, 실제 호스팅 연결 상태는 소유하지 않는다.

## 구성

- `.github/workflows/docs.yml`: 워크플로 1개, `release-v*` push 트리거 1종.
- `.github/workflows/slither.yml`: 워크플로 1개, `master`·`release-v*` push, PR, 수동 실행 트리거 3종.
- `.github/workflows/test.yml`: 워크플로 1개, 같은 트리거 3종, test·coverage job 2개.
- `.github/workflows/upgradeable.yml`: 워크플로 1개, `master`·`release-v*` push 트리거 1종.
- `netlify.toml`: 설정 파일 1개, build 명령 1개와 publish 경로 1개.
- M1 익스포트된 최상위 심볼: `(미확인 — AST_PATTERNS.md에 YAML/TOML 패턴 없음; 시도 경로 .github/workflows 및 netlify.toml)`.
- M2 진입점: `(미확인 — AST_PATTERNS.md에 YAML/TOML 패턴 없음; 시도 경로 .github/workflows 및 netlify.toml)`.
- M3 외부 클라이언트 생성 지점: `(미확인 — AST_PATTERNS.md에 YAML/TOML 패턴 없음; 시도 경로 .github/workflows 및 netlify.toml)`.
- M4 이 영역을 부르는 다른 영역: 0개. AST_PATTERNS.md의 고정 import `rg` 명령을 `.github` 영역명으로 실행했다.

## 데이터 흐름

`test.yml`은 checkout과 Node.js 12 설정 후 `npm ci`, `npm run lint`, `npm run test`, `npm run test:inheritance`를 실행하고 별도 job에서 `npm run coverage` 결과를 Codecov로 보낸다. `slither.yml`은 `npm run clean` 뒤 Slither action을 실행한다. `docs.yml`은 릴리스 브랜치에서 `scripts/update-docs-branch.js`를 실행해 생성 문서를 docs 브랜치에 커밋하고 origin으로 push한다. `upgradeable.yml`은 GitHub App 토큰을 받아 OpenZeppelin upgradeable 저장소에 repository dispatch를 보낸다.

## 의존

내부 의존은 `package.json`, `package-lock.json`, `scripts/update-docs-branch.js`, `hardhat.config.js`다. 외부 의존은 `actions/checkout@v3`, `actions/setup-node@v3`, `actions/cache@v3`, `codecov/codecov-action@v3`, `crytic/slither-action@v0.1.1`, `getsentry/action-github-app-token@v1`, GitHub REST API다. `netlify.toml`의 `npm run docs`는 현재 `package.json`에 정의되어 있지 않다.

## 근거

- `.github/workflows/docs.yml`, `slither.yml`, `test.yml`, `upgradeable.yml`, `netlify.toml`, `scripts/update-docs-branch.js`를 2026-09-19 읽었다.
- 워크플로 4개와 트리거는 파일의 `on:` 블록을 직접 셌다 (2026-09-19).
- `gh run list -R thingsflow/thingsflow-klaytn-contracts --limit 20 --json name,conclusion,event` 결과는 0건이다 (2026-09-19).
- M4 명령은 `rg -l --no-heading -g '!.github/**' -e "from ['\"].*.github/" -e "import .*\.github\." . | awk -F/ '{print $2}' | sort -u | grep -c . || true`이며 결과는 0이다 (2026-09-19).
