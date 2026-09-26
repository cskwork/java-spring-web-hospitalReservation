# Dr.Her 원본 화면 데모

이 폴더는 부모 저장소의 Spring MVC·MyBatis·JSP 화면을 읽어 정적 데모로 빌드합니다. 원본 Tiles 구성과 JSP·CSS·스크립트를 재사용하고, 서버 요청만 가상 데이터와 브라우저 저장소로 처리합니다. 실제 로그인·예약·결제·지도는 연결하지 않습니다.

`/hospital/workspace/`에는 계정·예약·후기·관심 병원·개인 정보·포인트·고객지원·관리자 업무를 연결한 새 작업 화면이 있습니다. 기존 JSP 변환 화면과 같은 가상 상태를 사용합니다. 전체 대응표는 [FULL-MODULE-MATRIX.md](../FULL-MODULE-MATRIX.md), 실제 서버 실행은 [NATIVE-RUNBOOK.md](../NATIVE-RUNBOOK.md)에 있습니다.

Node 18 이상에서 이 폴더를 기준으로 실행합니다.

```sh
npm ci
npm test
npm run build
python3 -m http.server 18923 --directory dist
```

`http://localhost:18923/`에서 시작합니다. 병원 검색·상세, 예약·취소, 관심 병원, 지난 방문의 후기 작성·완료, 평점 반영, 저장 후 새로고침과 초기화를 체험할 수 있습니다. 후기에는 네 항목(1~5점)과 1~500자 내용이 필요하며, 모의 저장 계층은 본인의 지난 방문·중복 작성을 검사합니다. 이 검사는 원본 서버의 보안 보장을 의미하지 않습니다. 생성 화면의 `hospital/demo/provenance.json`에 원본 파일과 해시, 변환 내역이 기록됩니다. 원본이 없거나 예상 문법이 달라지면 빌드가 실패합니다.

Vercel은 이 폴더를 Root Directory로 지정하고 상위 소스 포함을 켭니다. 또는 검증한 `dist/`만 정적 배포할 수 있습니다. 공개 배포에는 백엔드 설정·Java·운영 데이터·출처 불명 사진을 넣지 않습니다.

원본 팀 프로젝트의 제작자 표기를 유지합니다. Nantes 테마와 외부 라이브러리의 출처·라이선스는 `licenses/`에 있습니다. 데모는 공식 병원 서비스가 아닙니다.
