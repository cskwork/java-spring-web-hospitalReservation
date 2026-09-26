# java-spring-web-hospitalReservation
병원 예약 사이트

원본 Spring MVC·MyBatis·JSP 프로젝트를 유지하며, 14개 업무 모듈의 가상 데이터 데모와 실제 서버 실행 경로를 보완했습니다. 검색·예약·취소·후기·관심 병원·계정·문의·관리자 업무를 연결하고, 원본 화면과 새 작업 화면을 함께 재설계했습니다.

- 데모: `npm --prefix portfolio-demo ci && npm --prefix portfolio-demo test` 후 `portfolio-demo/dist/`를 정적으로 제공합니다. 모든 예약·결제·메일 데이터는 가상입니다.
- 실제 서버 소스: `mvn -Dmaven.repo.local=/tmp/hospital-m2 clean test package`로 빌드합니다. 환경 설정과 DB 준비는 [NATIVE-RUNBOOK.md](NATIVE-RUNBOOK.md)를 따릅니다.
- 기능과 원본 경로: [FULL-MODULE-MATRIX.md](FULL-MODULE-MATRIX.md).

검증한 범위는 데모 검사 48개, Java 검사 14개, 격리된 H2를 사용하는 실제 Tomcat·Spring·Tiles 구동과 한글 회원가입 저장입니다. 운영 Oracle·외부 로그인·결제·메일 연결, 브라우저 화면 검증, 새 Vercel 배포는 수행하지 않았습니다. 기존 운영 DB 변경과 오래된 프레임워크의 운영 적합성 검토는 별도 작업입니다.
