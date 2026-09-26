# Dr.Her 원본 화면 데모

이 폴더는 부모 저장소의 Spring MVC·MyBatis·JSP 화면을 읽어 정적 데모로 빌드합니다. 원본 Tiles 구성과 JSP·CSS·스크립트를 재사용하고, 서버 요청만 가상 데이터와 브라우저 저장소로 처리합니다. 실제 로그인·예약·결제·지도는 연결하지 않습니다.

Node 18 이상에서 이 폴더를 기준으로 실행합니다.

```sh
npm ci
npm test
npm run build
python3 -m http.server 18923 --directory dist
```

`http://localhost:18923/`에서 시작합니다. 병원 검색·상세, 예약·취소, 관심 병원, 저장 후 새로고침, 초기화를 체험할 수 있습니다. 생성 화면의 `hospital/demo/provenance.json`에 원본 파일과 해시, 변환 내역이 기록됩니다. 원본이 없거나 예상 문법이 달라지면 빌드가 실패합니다.

Vercel은 이 폴더를 Root Directory로 지정하고 상위 소스 포함을 켭니다. 또는 검증한 `dist/`만 정적 배포할 수 있습니다. 공개 배포에는 백엔드 설정·Java·운영 데이터·출처 불명 사진을 넣지 않습니다.

원본 팀 프로젝트의 제작자 표기를 유지합니다. Nantes 테마와 외부 라이브러리의 출처·라이선스는 `licenses/`에 있습니다. 데모는 공식 병원 서비스가 아닙니다.
