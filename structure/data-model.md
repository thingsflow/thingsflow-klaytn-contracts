# 데이터 모델

## 경계

이 영역은 `migrations/` 경로만 다룬다. 현재 트리에는 실행 가능한 마이그레이션, 데이터베이스 스키마, ORM 모델, SQL 파일이 없다. Solidity 계약 상태는 `contracts/`의 소유 범위이며 이 문서의 데이터베이스 모델로 분류하지 않는다.

## 구성

- `migrations/.gitkeep`: 추적 파일 1개.
- SQL 파일: 0개.
- M1 익스포트된 최상위 심볼: `(미확인 — 분석할 언어 파일 0개이며 AST_PATTERNS.md에 .gitkeep 패턴 없음; 시도 경로 migrations/)`.
- M2 진입점: `(미확인 — 분석할 언어 파일 0개이며 AST_PATTERNS.md에 .gitkeep 패턴 없음; 시도 경로 migrations/)`.
- M3 외부 클라이언트 생성 지점: `(미확인 — 분석할 언어 파일 0개이며 AST_PATTERNS.md에 .gitkeep 패턴 없음; 시도 경로 migrations/)`.
- M4 이 영역을 부르는 다른 영역: 0개. AST_PATTERNS.md의 고정 import `rg` 명령을 `migrations`에 실행했다.

## 데이터 흐름

실행되는 데이터 흐름은 없다. `migrations/`에는 `.gitkeep`만 있고 `package.json`에도 마이그레이션 명령이 없다.

## 의존

내부 모듈과 외부 패키지 의존은 없다. `measure.py`는 경로명 `migrations`를 감지해 이 문서를 생성 대상으로 분류한다.

## 근거

- `migrations/.gitkeep`, `package.json`을 2026-09-19 읽었다.
- `find migrations -type f` 결과는 파일 1개이고 `find . -name '*.sql'`과 `measure.py` 결과의 SQL 파일 수는 0개다 (2026-09-19).
- M4 명령은 `rg -l --no-heading -g '!migrations/**' -e "from ['\"].*migrations/" -e "import .*migrations\." . | awk -F/ '{print $2}' | sort -u | grep -c . || true`이며 결과는 0이다 (2026-09-19).
