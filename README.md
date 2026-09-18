> **유휴 추정.** 마지막 푸시가 2022-06-29이고 그 뒤 커밋이 없다.
> 아래 내용은 그 시점의 기록으로 읽는다. 현재 동작을 보장하지 않는다.
> 근거: GitHub REST API pushed_at (2026-09-19 조회).

# Klaytn Contracts

Klaytn용 보안 스마트 계약 라이브러리다. OpenZeppelin Contracts를 바탕으로 ERC 계열 구현과 KIP-7, KIP-17, KIP-37 구현을 제공한다. 저장소 구조와 현재 트리의 근거는 [structure/INDEX.md](structure/INDEX.md)에서 찾는다.

## 설치와 사용

배포 패키지는 다음 명령으로 설치한다.

```console
npm install @klaytn/contracts
```

릴리스 소스를 GitHub에서 직접 가져올 때는 `master` 대신 `v1.0.0` 같은 릴리스 태그를 지정한다.

```solidity
pragma solidity ^0.8.0;

import "@klaytn/contracts/KIP/token/KIP17/KIP17.sol";

contract MyCollectible is KIP17 {
    constructor() KIP17("MyCollectible", "MCO") {}
}
```

## 개발 명령

현재 `package.json`에 정의된 명령은 다음과 같다.

```bash
npm ci
npm run compile
npm test
npm run lint
npm run coverage
npm run test:inheritance
```

Hardhat 컴파일러 기본값은 Solidity `0.8.9`다. 테스트 경로와 최적화 조건은 `hardhat.config.js`에 있다.

## 문서와 지원

- [Klaytn 문서](https://docs.klaytn.foundation/)
- [npm 패키지](https://www.npmjs.com/package/@klaytn/contracts)
- [Ethereum과 Klaytn 토큰 표준 매핑](https://kips.klaytn.com/token)
- [기여 지침](CONTRIBUTING.md), [라이선스](LICENSE), [행동 강령](CODE_OF_CONDUCT.md)
- [Gitter](https://gitter.im/klaytn/klaytn-contracts), [Klaytn Developers Forum](https://forum.klaytn.foundation/), [Discord](https://discord.gg/mWsHFqN5Zf)

기존 README 원문은 [structure/legacy-readme.md](structure/legacy-readme.md)에 보존되어 있다.
