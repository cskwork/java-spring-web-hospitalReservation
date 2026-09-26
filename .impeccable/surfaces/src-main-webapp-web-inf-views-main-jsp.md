---
version: 1
slug: "src-main-webapp-web-inf-views-main-jsp"
primary_target: "src/main/webapp/WEB-INF/views/main.jsp"
related_targets: []
---

# 공공의료 예약 신청 창구

Mode: Operate. Scope: 이 저장소의 전체 메뉴·목록·상세·입력·관리 흐름. 사용자는 5개 별도 전문 서비스, 코드 우선 재설계를 승인했다. 기능 전체 복원/실사용 연결 작업과 함께 수행한다. 브라우저 조작과 배포는 보류, GitHub 반영은 승인됨.

## Direction contract

THESIS: 공공의료 예약 신청 창구에서 핵심 업무를 시작하고 완료한다. 원본의 외형과 낡은 조작 요소를 새로 설계하되 원본 업무·데이터 계약은 이어간다.

OWN-WORLD: 흰색·옅은 회색 바탕, 짙은 청록 액션, 남색 본문. 읽기 쉬운 한국어 sans, 넉넉한 행 간격, 단정한 10px 모서리. 오래된 슬라이더·지도 빈칸·이미지 메뉴를 교체한다.

STORY: 방문자는 실제 업무 항목을 보고 검색·등록·검토·저장하며 상태가 다음 화면에 이어지는 것을 확인한다. 합성 데이터와 실제 연결 환경은 명확히 구분한다.

FIRST VIEWPORT: 가로 주 탐색 아래 왼쪽 넓은 병원 검색과 진료과 필터, 오른쪽에는 다음 예약 또는 빈 예약 안내. 결과는 비교 가능한 행, 상세는 진료 정보와 예약 선택을 나란히 놓는다.

FORM: 후보 6, 공공의료 예약 신청 창구; seed key 0befca54. 후보 목록은 redesign-2026-09-26/direction-candidates.json에 기록했다. 사용자 지정 clean/professional을 우선하며 물리적 은유의 장식을 그대로 복제하지 않는다.

SIGNATURE: 예약 단계에서 선택한 병원·진료과·날짜·시간이 같은 요약 영역에 계속 보이고 완료 뒤 내 예약으로 연결된다. 상태 변화는 150–200ms 이내, reduced motion에서는 즉시 반영하고 처음부터 내용을 보인다.

FINISH: unreviewed and undocumented is unfinished; this build ends with the finish review, the verdict, DESIGN.md, and every shipping raster carrying its provenance

## Verification boundary

원본 기반 자동 검사와 새로운 역할별 실패/저장/권한 경계를 검사한다. 사용자 지시로 새 브라우저 캡처와 실제 화면 판정은 보류되며 코드 검토를 시각 통과로 표현하지 않는다. 새 장식 이미지는 필요하지 않다. 기능 원본이 없는 부분은 새 호환 구현으로 기록한다. 완성 뒤 실제 토큰에 근거한 DESIGN.md와 .impeccable/design.json을 작성한다.
