# AGENTS.md

## 이 저장소가 하는 일

이 저장소는 Solidity `0.8.x` 기반 스마트 계약 라이브러리와 Klaytn 토큰 표준 구현을 패키징하고 검증한다. 애플리케이션 서버나 체인 노드를 구현하는 저장소가 아니다.

## 읽는 순서

1. 이 `AGENTS.md`를 끝까지 읽는다.
2. [structure/INDEX.md](structure/INDEX.md)에서 스택, 명령, 디렉터리 경계를 확인한다.
3. 작업 영역에 맞춰 [structure/ci-and-deploy.md](structure/ci-and-deploy.md), [structure/data-model.md](structure/data-model.md), [structure/test.md](structure/test.md)를 읽는다.
4. 계약별 동작은 `contracts/**/README.adoc`, 사용 가이드는 `docs/modules/ROOT/pages/`, 테스트 규칙은 `test/TESTING.md`에서 확인한다.

## 저장소 구조

- `contracts/`는 KIP·ERC 계약, 인터페이스, 프록시, 거버넌스, 보안·유틸리티 구현을 소유한다.
- `test/`는 계약 디렉터리 구조에 대응하는 Hardhat/Truffle 테스트와 공통 테스트 헬퍼를 소유한다.
- `hardhat/`와 `hardhat.config.js`는 Hardhat 실행 환경, 컴파일러, 테스트 경로, 가스 리포트 설정을 소유한다.
- `scripts/`는 문서 생성, 패키징, 상속 순서 검사, import 마이그레이션 작업을 소유한다.
- `docs/`는 Antora 사용 가이드와 생성형 API 문서 템플릿을 소유한다.
- `certora/`는 Certora 명세, 하네스, 검증 스크립트를 소유한다.
- `.github/`는 CODEOWNERS, 이슈·PR 템플릿, 네 개의 Actions 워크플로를 소유한다.
- `migrations/`는 현재 `.gitkeep`만 포함한 마이그레이션 자리표시자다.

## 작업 규칙

- 기여 브랜치는 `master`에서 만들고 `fix/<이름>` 또는 `feature/<이름>` 형태를 사용한다. PR의 base는 `master`다.
- 변경 전 연결된 이슈가 준비되었는지 확인하고, PR 본문은 `.github/PULL_REQUEST_TEMPLATE.md`의 체크리스트와 관련 이슈 절을 채운다.
- 계약 변경에는 재현 가능한 테스트를 추가한다. 테스트 입력은 계정 생성 예외를 제외하고 무작위로 만들지 않는다.
- 제출 전 `npm test`, `npm run lint:fix`, `npm run lint`를 실행한다. 컴파일 영향이 있으면 `npm run compile`, 상속 영향이 있으면 `npm run test:inheritance`도 실행한다.
- Solidity는 공식 Solidity 스타일 가이드와 OpenZeppelin 스타일 가이드를 따른다. JavaScript와 Solidity 정적 검사는 `.eslintrc`, `.solhint.json`, `.prettierrc`를 따른다.
- 최근 100커밋에는 단일 강제 접두사 규칙이 없다. 커밋 제목은 변경 대상을 식별할 수 있는 명령형 설명으로 쓴다.
- 보안 문제는 공개 이슈 대신 `SECURITY.md`의 연락처로 보고한다.

## Code Review Rules

- 계약 변경에 해당 동작을 검증하는 테스트가 없으면 승인하지 않는다.
- 무작위 테스트 입력이 계정 생성 이외의 경로에 들어가면 승인하지 않는다.
- `npm test` 또는 `npm run lint` 실패가 남아 있으면 승인하지 않는다.
- 공개 계약 인터페이스, 이벤트, 저장소 레이아웃을 바꾸면서 문서와 호환성 설명을 갱신하지 않으면 승인하지 않는다.
- PR이 관련 이슈를 연결하지 않았거나 PR 템플릿 체크리스트를 비워 두었으면 승인하지 않는다.
- 생성 산출물, 빌드 결과, 자격증명, API 키를 커밋하면 승인하지 않는다.

## 하지 않는 것

- `contracts/` 구현을 사용처로 복사해 별도 수정본을 만들지 않는다.
- 기존 계약의 공개 API와 저장소 레이아웃을 근거 없이 바꾸지 않는다.
- `artifacts/`, `cache/`, `build/`, `node_modules/`를 소스처럼 커밋하지 않는다.
- 시크릿 값이나 로컬 `.env`를 커밋하지 않는다.
- 테스트·린트 확인 없이 PR 준비가 끝났다고 표시하지 않는다.

## 근거

- `structure/legacy-readme.md`: 라이브러리 목적, 설치·사용법, 외부 링크를 읽음 (2026-09-19).
- `CONTRIBUTING.md`: `master` 대상 PR, `fix/`·`feature/` 브랜치, 이슈·CLA·테스트·스타일 규칙을 읽음 (2026-09-19).
- `package.json`, `hardhat.config.js`, `.eslintrc`, `.solhint.json`, `.prettierrc`: 명령과 도구 설정을 읽음 (2026-09-19).
- `.github/CODEOWNERS`, `.github/PULL_REQUEST_TEMPLATE.md`, `.github/ISSUE_TEMPLATE/`, `.github/workflows/`: 리뷰 소유자, 템플릿, 자동화 규칙을 읽음 (2026-09-19).
- `test/TESTING.md`, `contracts/**/README.adoc`, `docs/modules/ROOT/`: 테스트 대응 구조와 계약·가이드 문서를 읽음 (2026-09-19).
- 기존 `AGENTS.md`와 `CLAUDE.md`는 없었으므로 흡수한 기존 규칙은 0건이다 (2026-09-19 확인).
