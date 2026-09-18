# 테스트 영역

## 경계

`test/`는 KIP·ERC 계약, 접근 제어, 거버넌스, 프록시, 보안, 유틸리티의 JavaScript 테스트와 공통 헬퍼를 소유한다. 계약 구현과 Hardhat 전역 설정은 각각 `contracts/`와 `hardhat.config.js`가 소유한다.

## 구성

- 전체 파일 166개: JavaScript 165개, `TESTING.md` 1개.
- 1단계 구성: `KIP/` 44개, `token/` 39개, `utils/` 37개, `governance/` 12개, `proxy/` 11개, `helpers/` 7개, `access/` 5개, `finance/` 3개, `security/` 3개, `metatx/` 2개, `crosschain/` 1개, 루트 테스트 1개, `TESTING.md` 1개.
- M1 익스포트된 최상위 심볼: 0개. 테스트 경로를 제외한 뒤 JS 1차 패턴 `export function $N($$$) { $$$ }`와 2차 패턴 `export const $N = $$$`를 validate→search했다.
- M2 진입점: Express/Nest GET 0개, POST 0개, PUT 0개, DELETE 0개, Lambda handler 0개, 합계 0개. 테스트 경로를 제외하고 각 고정 패턴을 validate→search했다.
- M3 외부 클라이언트 생성 지점: 0개. 테스트 경로를 제외하고 `new $C($$$)`, `createClient($$$)`, `createPool($$$)`, `axios.create($$$)`를 validate→search했다.
- M4 이 영역을 부르는 다른 영역: 0개. AST_PATTERNS.md의 고정 import `rg` 명령을 `test` 영역명으로 실행했다.

## 데이터 흐름

`npm test`는 `hardhat test`를 호출한다. `hardhat.config.js`의 `paths.tests`는 `./test/KIP/token/KIP7`을 지정하므로 기본 명령은 해당 KIP-7 테스트 경로를 읽는다. 테스트는 `artifacts.require`로 `contracts/mocks/`와 계약 산출물을 불러와 배포하고, OpenZeppelin test-helpers와 Chai로 상태·이벤트·revert를 검증한다. 동작 공유 파일은 `*.behavior.js`에서 테스트 함수를 제공하고 `*.test.js`가 이를 호출한다. `npm run coverage`는 `solidity-coverage`를 활성화하고, `npm run test:inheritance`는 빌드 정보의 상속 순서를 검사한다.

## 의존

내부 의존은 `contracts/`, `contracts/mocks/`, `test/helpers/`, `hardhat/env-contract.js`, `hardhat.config.js`다. 외부 패키지는 `@openzeppelin/test-helpers`, `chai`, `eth-sig-util`, `ethereumjs-util`, `ethereumjs-wallet`, `web3`, Hardhat의 Truffle 5 플러그인이다 (`package.json`, 2026-09-19 읽음).

## 근거

- `test/TESTING.md`, `test/KIP/token/KIP7/KIP7.test.js`, `test/governance/Governor.test.js`, `test/helpers/governance.js`, `hardhat.config.js`, `hardhat/env-contract.js`, `package.json`을 2026-09-19 읽고 세 곳을 스팟체크했다.
- 파일 수는 `find test -type f`와 확장자별 `find`로 셌고, 물리 줄 수 29,082와 코드 파일 165개는 `measure.py` 출력에서 확인했다 (2026-09-19).
- M1~M3은 `ast_grep_helper.py validate` 후 `search --lang js --globs '!**/test/**' --globs '!**/*test*' --globs '!**/*spec*' --globs '!**/*_generated.*'` 순서로 실행했다. 모든 검색은 성공 종료와 빈 JSON 배열을 반환했다 (2026-09-19).
- M4 명령은 `rg -l --no-heading -g '!test/**' -e "from ['\"].*test/" -e "import .*test\." . | awk -F/ '{print $2}' | sort -u | grep -c . || true`이며 결과는 0이다 (2026-09-19).
