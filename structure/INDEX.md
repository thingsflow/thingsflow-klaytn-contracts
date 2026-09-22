# 저장소 구조 인덱스

## 한 줄 요약

Klaytn KIP 토큰 표준과 OpenZeppelin 기반 ERC 계약을 npm 패키지로 제공하고 Hardhat 테스트·정적 분석·문서 자동화를 함께 보관하는 Solidity 라이브러리다.

읽는 순서는 이 문서에서 시작해 CI는 [ci-and-deploy.md](ci-and-deploy.md), 마이그레이션 자리표시자는 [data-model.md](data-model.md), 테스트 구조는 [test.md](test.md)로 이어진다.

| 소스 경로 | 구조 문서 |
|---|---|
| 저장소 루트, `contracts/`, `scripts/`, `docs/` | `structure/INDEX.md` |
| `.github/workflows/`, `netlify.toml` | `structure/ci-and-deploy.md` |
| `migrations/` | `structure/data-model.md` |
| `test/` | `structure/test.md` |

## 스택

- Solidity `^0.8.0`, Hardhat 기본 컴파일러 `0.8.9`: `contracts/KIP/token/KIP7/KIP7.sol`, `hardhat.config.js` (2026-09-19 읽음).
- JavaScript CommonJS와 Node.js `12.x` CI: `hardhat.config.js`, `.github/workflows/test.yml` (2026-09-19 읽음).
- Hardhat `^2.9.1`, Truffle 5·Web3 플러그인, Mocha·Chai, OpenZeppelin test-helpers: `package.json` (2026-09-19 읽음).
- npm과 lockfile v2: `package.json`, `package-lock.json` (2026-09-19 읽음).
- Solhint, ESLint, Prettier, Slither, Solidity Coverage, Certora: `.solhint.json`, `.eslintrc`, `.prettierrc`, `slither.config.json`, `.github/workflows/slither.yml`, `certora/README.md` (2026-09-19 읽음).

## 기본 브랜치와 배포

- 기본 브랜치는 `master` 1개다. GitHub REST API `.default_branch`를 조회했다 (2026-09-19).
- `.github/workflows/test.yml`과 `slither.yml`은 `master`, `release-v*` push와 PR, 수동 실행을 받는다. `upgradeable.yml`은 같은 두 push 브랜치에서 외부 저장소 dispatch를 호출한다 (워크플로 3개, 2026-09-19 읽음).
- `.github/workflows/docs.yml`은 `release-v*` push에서 `scripts/update-docs-branch.js`를 실행하고 docs 브랜치를 갱신해 origin에 push한다 (워크플로 1개, 2026-09-19 읽음).
- `netlify.toml`은 `npm run docs`와 `build/site`를 선언하지만 현재 `package.json`에는 `docs` 스크립트가 없다 (설정 1건, 2026-09-19 읽음).
- `gh run list --limit 20` 결과는 0건이다 (2026-09-19 조회).

## 디렉터리

- `contracts/` — Solidity 파일 390개, 26,975줄. `KIP/` 123개, `mocks/` 100개, `token/` 47개, `utils/` 34개, `interfaces/` 25개를 중심으로 계약 구현을 소유한다 (2026-09-19 실측).
- `test/` — 파일 166개 중 JavaScript 165개. `KIP/`, `token/`, `utils/`, `governance/`, `proxy/`, `helpers/`가 계약 구조에 대응한다 (2026-09-19 실측).
- `docs/` — 추적 파일 24개. Antora 가이드, 템플릿, 이미지, API 문서 내비게이션을 소유한다 (2026-09-19 실측).
- `scripts/` — 추적 파일 15개. 패키징, 문서 생성, 상속 순서 검사, import 변환을 소유한다 (2026-09-19 실측).
- `certora/` — 추적 파일 17개. 명세, 하네스, 패치, 검증 스크립트를 소유한다 (2026-09-19 실측).
- `audit/` — 추적 파일 2개. 과거 감사 기록을 보존한다 (2026-09-19 실측).
- `hardhat/` — 환경 확장 파일 1개. 테스트 계정에서 배포자 계정을 제외한다 (2026-09-19 읽음).
- `migrations/` — `.gitkeep` 1개만 있는 자리표시자다 (2026-09-19 실측).

## 이 저장소의 문서는 어디에 있나

`docs/`는 팀이 쓰고 코드와 함께 움직인다. 이 문서가 그것을 대체하지 않고 가리킨다.

| 찾는 것 | 가는 곳 |
|---|---|
| Antora 문서 구성 | [docs/antora.yml](../docs/antora.yml) |
| 문서 내비게이션 | [docs/modules/ROOT/nav.adoc](../docs/modules/ROOT/nav.adoc) |

## 다른 저장소와 어떻게 이어지나

확인된 사내 저장소 관계 없음 (워크플로·매니페스트·서브모듈·호스트 호출, 2026-09-19 조회)

## 진입점

- 설치: `npm ci`; 패키지 사용: `npm install @klaytn/contracts` (`package-lock.json`, `structure/legacy-readme.md`, 2026-09-19 읽음).
- 컴파일·정리: `npm run compile`, `npm run clean` (`package.json`, 2026-09-19 읽음).
- 테스트·커버리지: `npm test`, `npm run coverage`, `npm run test:inheritance`, `npm run gas-report` (`package.json`, 2026-09-19 읽음).
- 정적 검사·포맷: `npm run lint`, `npm run lint:fix`, `npm run lint:js`, `npm run lint:sol` (`package.json`, 2026-09-19 읽음).
- import 변환 CLI: `klaytn-contracts-migrate-imports` → `scripts/migrate-imports.js` (`package.json`, 2026-09-19 읽음).
- Certora: `sh certora/scripts/verifyAll.sh <comment>` (`certora/README.md`, 2026-09-19 읽음).

## 내부 설계

`contracts/`는 인터페이스와 공통 유틸리티 위에 ERC·KIP 계약을 쌓고, `mocks/`가 테스트용 구체 구현을 제공한다. KIP-7·17·37 핵심 계약은 각각 잔액·소유권·승인 상태를 관리하고 KIP-13 인터페이스 검사를 공유한다 (`contracts/KIP/token/KIP7/KIP7.sol`, `KIP17/KIP17.sol`, `KIP37/KIP37.sol`, 2026-09-19 읽음).

개발 흐름은 `package.json` 스크립트가 Hardhat을 호출하고, `hardhat.config.js`가 `contracts/`를 컴파일해 `artifacts/`를 만든 뒤, `test/`의 JavaScript가 `artifacts.require`로 mock과 계약을 배포·검증하는 구조다. 패키징 시 `scripts/prepack.sh`가 ABI 산출물을 `build/contracts/`로 복사하고 무시 대상 산출물을 제거한다 (2026-09-19 읽음).

문서 흐름은 `docs/modules/ROOT/pages/`의 가이드와 계약별 `README.adoc`를 원본으로 삼는다. `scripts/prepare-docs.sh`는 Solidity 문서를 생성하고 `scripts/gen-nav.js`가 API 내비게이션을 만든다 (2026-09-19 읽음).

## 규약(실측)

- 원격 브랜치 4개는 모두 `/` 경로 접두사가 없는 루트 이름이다: `origin/master`, `origin/release-v1.0.1`, `origin/time-capsule`, `upstream/main` 각 1개 (`git branch -r`, 2026-09-19 조회).
- 최근 100커밋 첫 토큰 접두사 분포는 `Add` 15, `Fix` 15, `Update` 10, `Merge` 7, `added` 6, `adding` 5, `Improve` 3, `Use` 3, `Bump` 2, `Optimize` 2, `Refactor` 2, `Remove` 2, `add` 2, `make` 2, `refactoring` 2, 나머지 `Align`, `Allow`, `Annotate`, `Change`, `Inherit`, `Make`, `Match`, `Move`, `Release`, `Rename`, `Replace`, `docs(erc1155)`, `external`, `fixed`, `increase`, `open`, `path`, `segregate`, `spelling`, `typo`, `updated`, `updating`이 각 1개다 (`git log -100 --pretty=%s`, 2026-09-19 조회).
- `CONTRIBUTING.md`는 `master` base, `fix/`·`feature/` head, 관련 이슈, CLA, 테스트·린트를 요구한다. `.github/PULL_REQUEST_TEMPLATE.md`는 변경 유형 3개와 체크 항목 6개를 둔다 (2026-09-19 읽음).
- `.github/CODEOWNERS`는 전체 경로 규칙 1개에 소유자 4명을 지정한다. 이슈 템플릿은 3개다 (2026-09-19 읽음).

## PR 흐름(실측)

- 머지된 PR 표본은 0건이며 base←head 쌍, 리뷰, 라벨 표본도 0건이다 (`gh pr list --state merged --limit 30`, 2026-09-19 조회).
- merge commit, squash merge, rebase merge 허용 값은 각각 `true`, `true`, `true`다 (GitHub REST API, 2026-09-19 조회).
- `master` 브랜치 보호 조회는 HTTP 404이므로 보호 없음이다. 필수 검사는 0개, 필수 승인자 수는 설정 없음이다 (GitHub REST API, 2026-09-19 조회).
- ruleset 응답은 빈 배열로 0개다 (GitHub REST API, 2026-09-19 조회).

## 흡수한 문서

- `docs/`의 추적 파일 24개에서 설치, 확장, 업그레이드, 안정성, 접근 제어, 토큰, 거버넌스, 크로스체인, 유틸리티 가이드 지도를 가져왔다 (2026-09-19 읽음).
- `contracts/` 아래 README 23개에서 KIP-7·17·37, ERC-20·721·777·1155, 접근 제어, 프록시, 거버넌스, 인터페이스, 보안, 유틸리티 경계를 가져왔다 (2026-09-19 읽음).
- `certora/README.md`에서 검증 명령과 하네스 패치 흐름, `test/TESTING.md`에서 `test/`와 `contracts/`의 대응 규칙을 가져왔다 (2026-09-19 읽음).

## 이관 기록

- 이관 12건: 설치 명령 1건, 릴리스 태그 지침 1건, import 사용 예 1건, 문서·npm·KIP 링크 3건, 기여·라이선스·행동 강령 경로 3건, Gitter·포럼·Discord 지원 링크 3건을 새 `README.md`로 옮겼다.
- legacy 보존 3건: 기여 철학 설명, 설치 코드 수정 금지 안내 문단, 감사 문구는 `structure/legacy-readme.md`에만 보존했다.

## 근거

- 로컬 경로: `package.json`, `package-lock.json`, `contracts/package.json`, `hardhat.config.js`, `netlify.toml`, `.github/`, `contracts/`, `test/`, `docs/`, `scripts/`, `certora/`, `CONTRIBUTING.md`, `SECURITY.md`, `structure/legacy-readme.md`를 2026-09-19 읽었다.
- 구조 측정: `python3 /Users/jun/Developer/newa/_gov/ax-native/measure.py /Users/jun/Developer/newa/repos/thingsflow-klaytn-contracts`를 2026-09-19 실행했다.
- Git 실측: `git log -100 --pretty=%s`, `git branch -r`, `git rev-list --count HEAD`, `git ls-files`, `find`, `wc -l`을 2026-09-19 실행했다.
- GitHub 실측: 저장소·브랜치 보호·ruleset REST API, 머지 PR 30건, 머지 방식, 최근 Actions 20건을 2026-09-19 조회했다.

## 티어C 정리로 흡수한 문서 (2026-09-19)

사양은 티어 C가 structure/INDEX.md 한 장이다. 아래 문서들이 별도 파일로
있었고 내용을 여기로 옮긴 뒤 파일을 지웠다. 버린 내용은 없다.

### 원래 structure/ci-and-deploy.md

## CI와 배포

### 경계

이 영역은 `.github/workflows/`의 테스트·정적 분석·문서 브랜치·업그레이드 연동과 `netlify.toml`의 사이트 빌드 선언을 소유한다. 계약 구현, 테스트 본문, GitHub 조직 설정, 실제 호스팅 연결 상태는 소유하지 않는다.

### 구성

- `.github/workflows/docs.yml`: 워크플로 1개, `release-v*` push 트리거 1종.
- `.github/workflows/slither.yml`: 워크플로 1개, `master`·`release-v*` push, PR, 수동 실행 트리거 3종.
- `.github/workflows/test.yml`: 워크플로 1개, 같은 트리거 3종, test·coverage job 2개.
- `.github/workflows/upgradeable.yml`: 워크플로 1개, `master`·`release-v*` push 트리거 1종.
- `netlify.toml`: 설정 파일 1개, build 명령 1개와 publish 경로 1개.
- M1 익스포트된 최상위 심볼: `(미확인 — AST_PATTERNS.md에 YAML/TOML 패턴 없음; 시도 경로 .github/workflows 및 netlify.toml)`.
- M2 진입점: `(미확인 — AST_PATTERNS.md에 YAML/TOML 패턴 없음; 시도 경로 .github/workflows 및 netlify.toml)`.
- M3 외부 클라이언트 생성 지점: `(미확인 — AST_PATTERNS.md에 YAML/TOML 패턴 없음; 시도 경로 .github/workflows 및 netlify.toml)`.
- M4 이 영역을 부르는 다른 영역: 0개. AST_PATTERNS.md의 고정 import `rg` 명령을 `.github` 영역명으로 실행했다.

### 데이터 흐름

`test.yml`은 checkout과 Node.js 12 설정 후 `npm ci`, `npm run lint`, `npm run test`, `npm run test:inheritance`를 실행하고 별도 job에서 `npm run coverage` 결과를 Codecov로 보낸다. `slither.yml`은 `npm run clean` 뒤 Slither action을 실행한다. `docs.yml`은 릴리스 브랜치에서 `scripts/update-docs-branch.js`를 실행해 생성 문서를 docs 브랜치에 커밋하고 origin으로 push한다. `upgradeable.yml`은 GitHub App 토큰을 받아 OpenZeppelin upgradeable 저장소에 repository dispatch를 보낸다.

### 의존

내부 의존은 `package.json`, `package-lock.json`, `scripts/update-docs-branch.js`, `hardhat.config.js`다. 외부 의존은 `actions/checkout@v3`, `actions/setup-node@v3`, `actions/cache@v3`, `codecov/codecov-action@v3`, `crytic/slither-action@v0.1.1`, `getsentry/action-github-app-token@v1`, GitHub REST API다. `netlify.toml`의 `npm run docs`는 현재 `package.json`에 정의되어 있지 않다.

### 근거

- `.github/workflows/docs.yml`, `slither.yml`, `test.yml`, `upgradeable.yml`, `netlify.toml`, `scripts/update-docs-branch.js`를 2026-09-19 읽었다.
- 워크플로 4개와 트리거는 파일의 `on:` 블록을 직접 셌다 (2026-09-19).
- `gh run list -R thingsflow/thingsflow-klaytn-contracts --limit 20 --json name,conclusion,event` 결과는 0건이다 (2026-09-19).
- M4 명령은 `rg -l --no-heading -g '!.github/**' -e "from ['\"].*.github/" -e "import .*\.github\." . | awk -F/ '{print $2}' | sort -u | grep -c . || true`이며 결과는 0이다 (2026-09-19).

### 원래 structure/data-model.md

## 데이터 모델

### 경계

이 영역은 `migrations/` 경로만 다룬다. 현재 트리에는 실행 가능한 마이그레이션, 데이터베이스 스키마, ORM 모델, SQL 파일이 없다. Solidity 계약 상태는 `contracts/`의 소유 범위이며 이 문서의 데이터베이스 모델로 분류하지 않는다.

### 구성

- `migrations/.gitkeep`: 추적 파일 1개.
- SQL 파일: 0개.
- M1 익스포트된 최상위 심볼: `(미확인 — 분석할 언어 파일 0개이며 AST_PATTERNS.md에 .gitkeep 패턴 없음; 시도 경로 migrations/)`.
- M2 진입점: `(미확인 — 분석할 언어 파일 0개이며 AST_PATTERNS.md에 .gitkeep 패턴 없음; 시도 경로 migrations/)`.
- M3 외부 클라이언트 생성 지점: `(미확인 — 분석할 언어 파일 0개이며 AST_PATTERNS.md에 .gitkeep 패턴 없음; 시도 경로 migrations/)`.
- M4 이 영역을 부르는 다른 영역: 0개. AST_PATTERNS.md의 고정 import `rg` 명령을 `migrations`에 실행했다.

### 데이터 흐름

실행되는 데이터 흐름은 없다. `migrations/`에는 `.gitkeep`만 있고 `package.json`에도 마이그레이션 명령이 없다.

### 의존

내부 모듈과 외부 패키지 의존은 없다. `measure.py`는 경로명 `migrations`를 감지해 이 문서를 생성 대상으로 분류한다.

### 근거

- `migrations/.gitkeep`, `package.json`을 2026-09-19 읽었다.
- `find migrations -type f` 결과는 파일 1개이고 `find . -name '*.sql'`과 `measure.py` 결과의 SQL 파일 수는 0개다 (2026-09-19).
- M4 명령은 `rg -l --no-heading -g '!migrations/**' -e "from ['\"].*migrations/" -e "import .*migrations\." . | awk -F/ '{print $2}' | sort -u | grep -c . || true`이며 결과는 0이다 (2026-09-19).

### 원래 structure/test.md

## 테스트 영역

### 경계

`test/`는 KIP·ERC 계약, 접근 제어, 거버넌스, 프록시, 보안, 유틸리티의 JavaScript 테스트와 공통 헬퍼를 소유한다. 계약 구현과 Hardhat 전역 설정은 각각 `contracts/`와 `hardhat.config.js`가 소유한다.

### 구성

- 전체 파일 166개: JavaScript 165개, `TESTING.md` 1개.
- 1단계 구성: `KIP/` 44개, `token/` 39개, `utils/` 37개, `governance/` 12개, `proxy/` 11개, `helpers/` 7개, `access/` 5개, `finance/` 3개, `security/` 3개, `metatx/` 2개, `crosschain/` 1개, 루트 테스트 1개, `TESTING.md` 1개.
- M1 익스포트된 최상위 심볼: 0개. 테스트 경로를 제외한 뒤 JS 1차 패턴 `export function $N($$$) { $$$ }`와 2차 패턴 `export const $N = $$$`를 validate→search했다.
- M2 진입점: Express/Nest GET 0개, POST 0개, PUT 0개, DELETE 0개, Lambda handler 0개, 합계 0개. 테스트 경로를 제외하고 각 고정 패턴을 validate→search했다.
- M3 외부 클라이언트 생성 지점: 0개. 테스트 경로를 제외하고 `new $C($$$)`, `createClient($$$)`, `createPool($$$)`, `axios.create($$$)`를 validate→search했다.
- M4 이 영역을 부르는 다른 영역: 0개. AST_PATTERNS.md의 고정 import `rg` 명령을 `test` 영역명으로 실행했다.

### 데이터 흐름

`npm test`는 `hardhat test`를 호출한다. `hardhat.config.js`의 `paths.tests`는 `./test/KIP/token/KIP7`을 지정하므로 기본 명령은 해당 KIP-7 테스트 경로를 읽는다. 테스트는 `artifacts.require`로 `contracts/mocks/`와 계약 산출물을 불러와 배포하고, OpenZeppelin test-helpers와 Chai로 상태·이벤트·revert를 검증한다. 동작 공유 파일은 `*.behavior.js`에서 테스트 함수를 제공하고 `*.test.js`가 이를 호출한다. `npm run coverage`는 `solidity-coverage`를 활성화하고, `npm run test:inheritance`는 빌드 정보의 상속 순서를 검사한다.

### 의존

내부 의존은 `contracts/`, `contracts/mocks/`, `test/helpers/`, `hardhat/env-contract.js`, `hardhat.config.js`다. 외부 패키지는 `@openzeppelin/test-helpers`, `chai`, `eth-sig-util`, `ethereumjs-util`, `ethereumjs-wallet`, `web3`, Hardhat의 Truffle 5 플러그인이다 (`package.json`, 2026-09-19 읽음).

### 근거

- `test/TESTING.md`, `test/KIP/token/KIP7/KIP7.test.js`, `test/governance/Governor.test.js`, `test/helpers/governance.js`, `hardhat.config.js`, `hardhat/env-contract.js`, `package.json`을 2026-09-19 읽고 세 곳을 스팟체크했다.
- 파일 수는 `find test -type f`와 확장자별 `find`로 셌고, 물리 줄 수 29,082와 코드 파일 165개는 `measure.py` 출력에서 확인했다 (2026-09-19).
- M1~M3은 `ast_grep_helper.py validate` 후 `search --lang js --globs '!**/test/**' --globs '!**/*test*' --globs '!**/*spec*' --globs '!**/*_generated.*'` 순서로 실행했다. 모든 검색은 성공 종료와 빈 JSON 배열을 반환했다 (2026-09-19).
- M4 명령은 `rg -l --no-heading -g '!test/**' -e "from ['\"].*test/" -e "import .*test\." . | awk -F/ '{print $2}' | sort -u | grep -c . || true`이며 결과는 0이다 (2026-09-19).

## 문서 변경과 자동 배포 (2026-09-22)

`.github/workflows/upgradeable.yml`은 GitHub 호스티드 러너의 `docs_changes` 잡에서 변경 경로를 먼저 확인한다.
루트 `AGENTS.md`·`README.md`·`CLAUDE.md`, `structure/` 아래 Markdown·`manifest.json`,
이 워크플로 파일만 바뀌면 배포 잡을 건너뛴다. 워크플로만 수정한 경우도 기존 코드를 즉시
재배포하지 않으며, 다음 실행 코드 변경이나 기존 수동 실행에서 새 설정이 적용된다.
실행 코드가 하나라도 함께 바뀌면 기존 배포가 실행된다. 변경 파일 판정에 실패하면 배포하지 않는다.
필수 테스트와 별도 워크플로의 트리거는 유지한다.
