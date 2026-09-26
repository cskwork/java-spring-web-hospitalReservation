/*
 * Dr.Her 데모용 합성(가상) 데이터. 실제 병원·인물·연락처와 무관합니다.
 *
 * 컬럼 이름은 원본 Oracle 테이블(MyBatis 매퍼 기준)을 그대로 따른다.
 *  - HOSPITAL : src/main/resources/mapper/jw/hplist_SQL.xml, sy/reserv_SQL.xml, jw/Admin_SQL.xml
 *               H_IDX, HOSP, MAJOR, TEL, ADDR, ADDR_GPS("위도,경도"), ONHOUR/OFFHOUR("HHMM"),
 *               INTERVALL(분, 문자열), MEAL_TIME("HHMM", 앞 두 자리 '시'만 사용), H_COMM, DOC_COMM,
 *               REG_CHK('Y' 예약 가능), DEL_CHK('0' 사용 중)
 *  - RATING   : H_IDX, ID, RATE1~RATE4, COMM, REG (common/Common_SQL.xml selectReview)
 *  - MEMBER   : ID, NAME (sk/member_SQL.xml)
 *  - RESERVATION : NUM, H_IDX, ID, CURED, RESERV1("YYYY/MM/DD"), RESERV2("HH:MM"), DEL_CHK, STATE
 *
 * 병원 이름·소개·진료시간 값은 ../../demos/hospital/public/js/data.js 의 합성 데이터를
 * 원본 컬럼 계약(진료과목 1개 문자열, HHMM 문자열, 분 단위 문자열 간격)에 맞게 옮겼다.
 */
(function (root, factory) {
  var api = factory();
  if (typeof module === 'object' && module.exports) module.exports = api;
  else root.DrHerFixtures = api;
})(typeof self !== 'undefined' ? self : this, function () {
  'use strict';

  var HOSPITAL = [
    { H_IDX: 1, HOSP: '햇살내과의원', MAJOR: '내과', TEL: '000-0101-0001', ADDR: '가상시 햇살동 12-3, 2층', ADDR_GPS: '37.5010,127.0250',
      ONHOUR: '0900', OFFHOUR: '1800', INTERVALL: '30', MEAL_TIME: '1300', REG_CHK: 'Y', DEL_CHK: '0',
      H_COMM: '감기·위장 질환부터 만성질환 관리까지 동네 주치의 역할을 하는 가상의 내과입니다.',
      DOC_COMM: '가상 의사 김하람 원장 — 소화기 내과 진료, 건강검진 상담 / 가상 의사 이도윤 — 고혈압·당뇨 등 만성질환 관리' },
    { H_IDX: 2, HOSP: '강변어린이병원', MAJOR: '소아청소년과', TEL: '000-0102-0002', ADDR: '가상시 강변동 45, 1~3층', ADDR_GPS: '37.5120,127.0400',
      ONHOUR: '0830', OFFHOUR: '1730', INTERVALL: '20', MEAL_TIME: '1200', REG_CHK: 'Y', DEL_CHK: '0',
      H_COMM: '영유아 예방 상담과 호흡기 진료를 함께 보는 가상의 어린이 병원입니다.',
      DOC_COMM: '가상 의사 박소망 원장 — 영유아 발달·예방접종 상담 / 가상 의사 최누리 — 소아 호흡기·알레르기' },
    { H_IDX: 3, HOSP: '바른걸음정형외과', MAJOR: '정형외과', TEL: '000-0103-0003', ADDR: '가상시 중앙동 7-1, 4층', ADDR_GPS: '37.4980,127.0310',
      ONHOUR: '0930', OFFHOUR: '1830', INTERVALL: '30', MEAL_TIME: '1300', REG_CHK: 'Y', DEL_CHK: '0',
      H_COMM: '관절·척추 통증과 운동 손상을 진료하는 가상의 정형외과입니다.',
      DOC_COMM: '가상 의사 한결 원장 — 무릎·어깨 관절, 스포츠 손상 / 가상 의사 윤서진 — 척추 통증, 자세 교정 상담' },
    { H_IDX: 4, HOSP: '맑은피부과', MAJOR: '피부과', TEL: '000-0104-0004', ADDR: '가상시 햇살동 30, 5층', ADDR_GPS: '37.5030,127.0270',
      ONHOUR: '1000', OFFHOUR: '1900', INTERVALL: '30', MEAL_TIME: '1400', REG_CHK: 'N', DEL_CHK: '0',
      H_COMM: '여드름·아토피 등 일반 피부 질환을 진료하는 가상의 피부과입니다. (온라인 예약 미참여 병원)',
      DOC_COMM: '가상 의사 서다온 원장 — 아토피·접촉성 피부염' },
    { H_IDX: 5, HOSP: '숲속이비인후과', MAJOR: '이비인후과', TEL: '000-0105-0005', ADDR: '가상시 숲마을 3길 8', ADDR_GPS: '37.5200,127.0500',
      ONHOUR: '0900', OFFHOUR: '1800', INTERVALL: '15', MEAL_TIME: '1200', REG_CHK: 'Y', DEL_CHK: '0',
      H_COMM: '비염·축농증·어지럼증을 진료하는 가상의 이비인후과입니다.',
      DOC_COMM: '가상 의사 오하늘 원장 — 비염·수면 호흡 상담 / 가상 의사 문지안 — 어지럼증·청력 검사' },
    { H_IDX: 6, HOSP: '또렷안과', MAJOR: '안과', TEL: '000-0106-0006', ADDR: '가상시 중앙동 19, 6층', ADDR_GPS: '37.4970,127.0330',
      ONHOUR: '0900', OFFHOUR: '1730', INTERVALL: '30', MEAL_TIME: '1300', REG_CHK: 'Y', DEL_CHK: '0',
      H_COMM: '시력 검사와 안구건조증 등 일반 안과 진료를 하는 가상의 안과입니다.',
      DOC_COMM: '가상 의사 배시우 원장 — 안구건조증·시력 검사' },
    { H_IDX: 7, HOSP: '하얀미소치과', MAJOR: '치과', TEL: '000-0107-0007', ADDR: '가상시 강변동 88, 2층', ADDR_GPS: '37.5140,127.0420',
      ONHOUR: '1000', OFFHOUR: '1900', INTERVALL: '60', MEAL_TIME: '1300', REG_CHK: 'Y', DEL_CHK: '0',
      H_COMM: '정기 검진·스케일링·충치 치료를 하는 가상의 치과입니다.',
      DOC_COMM: '가상 의사 류가을 원장 — 보존 치료·스케일링 / 가상 의사 장새봄 — 치주 질환 상담' },
    { H_IDX: 8, HOSP: '온누리여성의원', MAJOR: '산부인과', TEL: '000-0108-0008', ADDR: '가상시 숲마을 1길 21', ADDR_GPS: '37.5180,127.0480',
      ONHOUR: '0900', OFFHOUR: '1700', INTERVALL: '30', MEAL_TIME: '1200', REG_CHK: 'N', DEL_CHK: '0',
      H_COMM: '여성 건강 검진과 상담 중심의 가상의 산부인과입니다. (온라인 예약 미참여 병원)',
      DOC_COMM: '가상 의사 신아름 원장 — 여성 건강 검진 상담' },
    { H_IDX: 9, HOSP: '가온종합의원', MAJOR: '가정의학과', TEL: '000-0109-0009', ADDR: '가상시 중앙동 1, 가온빌딩', ADDR_GPS: '37.4990,127.0290',
      ONHOUR: '0830', OFFHOUR: '1830', INTERVALL: '30', MEAL_TIME: '1200', REG_CHK: 'Y', DEL_CHK: '0',
      H_COMM: '예방 상담과 일반 진료를 함께 보는 가상의 종합 의원입니다.',
      DOC_COMM: '가상 의사 임도현 원장 — 일반 진료·예방 상담 / 가상 의사 황보라 — 관절 통증·물리치료 상담' },
    { H_IDX: 10, HOSP: '새싹소아과의원', MAJOR: '소아청소년과', TEL: '000-0110-0010', ADDR: '가상시 숲마을 5길 2', ADDR_GPS: '37.5220,127.0520',
      ONHOUR: '0900', OFFHOUR: '1800', INTERVALL: '20', MEAL_TIME: '1300', REG_CHK: 'Y', DEL_CHK: '0',
      H_COMM: '성장 상담과 소아 감기 진료를 하는 가상의 소아과입니다.',
      DOC_COMM: '가상 의사 마루 원장 — 성장·영양 상담' }
  ];

  // MEMBER: 관리자 계정은 원본 selectMEMBERCount 처럼 회원 수에서 빠진다(COUNT(*)-1).
  var MEMBER = [
    { ID: 'admin', NAME: '관리자' },
    { ID: 'demo', NAME: '체험환자(가상)' },
    { ID: 'sample01', NAME: '가상 이용자 A' },
    { ID: 'sample02', NAME: '가상 이용자 B' },
    { ID: 'sample03', NAME: '가상 이용자 C' },
    { ID: 'sample04', NAME: '가상 이용자 D' },
    { ID: 'sample05', NAME: '가상 이용자 E' },
    { ID: 'sample06', NAME: '가상 이용자 F' },
    { ID: 'sample07', NAME: '가상 이용자 G' },
    { ID: 'sample08', NAME: '가상 이용자 H' }
  ];

  // RATING: 원본 만족도 조사(Rate.jsp) 4개 항목 = RATE1~RATE4 (1~5점)
  var RATING = [
    { H_IDX: 1, ID: 'sample01', RATE1: 5, RATE2: 4, RATE3: 5, RATE4: 3, REG: '2026-08-02', COMM: '설명을 차근차근 해 주셔서 이해하기 쉬웠어요. 오전에는 대기가 조금 있었습니다.' },
    { H_IDX: 1, ID: 'sample02', RATE1: 4, RATE2: 5, RATE3: 4, RATE4: 4, REG: '2026-07-18', COMM: '접수부터 진료까지 친절했습니다.' },
    { H_IDX: 2, ID: 'sample03', RATE1: 5, RATE2: 5, RATE3: 5, RATE4: 2, REG: '2026-08-11', COMM: '아이가 무서워하지 않게 잘 달래 주셨어요. 주말 전날은 붐빕니다.' },
    { H_IDX: 3, ID: 'sample04', RATE1: 4, RATE2: 4, RATE3: 5, RATE4: 4, REG: '2026-06-30', COMM: '운동 방법까지 알려 주셔서 도움이 됐습니다.' },
    { H_IDX: 4, ID: 'sample05', RATE1: 3, RATE2: 4, RATE3: 5, RATE4: 3, REG: '2026-08-20', COMM: '깔끔하고 조용한 분위기였어요.' },
    { H_IDX: 5, ID: 'sample06', RATE1: 5, RATE2: 4, RATE3: 4, RATE4: 5, REG: '2026-08-05', COMM: '예약 시간에 거의 바로 진료받았습니다.' },
    { H_IDX: 7, ID: 'sample07', RATE1: 5, RATE2: 5, RATE3: 5, RATE4: 4, REG: '2026-07-09', COMM: '스케일링이 꼼꼼했어요.' },
    { H_IDX: 9, ID: 'sample08', RATE1: 4, RATE2: 3, RATE3: 4, RATE4: 3, REG: '2026-08-14', COMM: '여러 진료를 한 번에 볼 수 있어 편했습니다.' },
    { H_IDX: 9, ID: 'sample01', RATE1: 4, RATE2: 4, RATE3: 3, RATE4: 4, REG: '2026-06-21', COMM: '무난했습니다.' },
    { H_IDX: 10, ID: 'sample02', RATE1: 5, RATE2: 5, RATE3: 4, RATE4: 4, REG: '2026-08-25', COMM: '성장 곡선을 자세히 설명해 주셔서 좋았어요.' }
  ];

  // 데모 세션: 로그인 대신 고정된 가상 별칭 하나로 동작한다.
  var SESSION = { ID: 'demo', NAME: '체험환자(가상)', ID_IMG: 'N' };

  // 브라우저 저장소 초기값. 지난 예약 화면이 비어 보이지 않도록 과거 예약 1건(기간만료)을 둔다.
  var SEED_STATE = {
    version: 1,
    POINT: 1000,
    RESERV_SEQ: 2,
    RESERVATION: [
      { NUM: 1, H_IDX: 3, ID: 'demo', CURED: '정형외과', RESERV1: '2026/08/14', RESERV2: '10:30', DEL_CHK: 'A', STATE: '미완료' }
    ],
    FAV: [{ H_IDX: 2, ID: 'demo' }]
  };

  return { HOSPITAL: HOSPITAL, MEMBER: MEMBER, RATING: RATING, SESSION: SESSION, SEED_STATE: SEED_STATE };
});
