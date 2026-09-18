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
