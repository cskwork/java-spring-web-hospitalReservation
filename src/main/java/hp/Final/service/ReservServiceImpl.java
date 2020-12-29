package hp.Final.service;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import hp.Final.dao.MypageDAO;
import hp.Final.dao.ReservDAO;

@Service("reservService")
public class ReservServiceImpl implements ReservService {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "ReservDAO")
	private ReservDAO reservDAO;

	@Resource(name = "MypageDAO")
	private MypageDAO mypageDAO;

	// 예약가능한 병원명 목록
	@Override
	public List<Map<String, Object>> selectHpList(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> hplist = reservDAO.selectHpList(map);

		return hplist;
	}

	// 병원별 예약가능시간
	@Override
	public List<String> selectDate(Map<String, Object> map) throws Exception {
		// 날짜 포맷형식
		SimpleDateFormat date = new SimpleDateFormat("yyyy/MM/dd");
		String today = date.format(new Date());

		map.put("DATE", today);

		Map<String, Object> HpMap = reservDAO.selectDate(map);
		List<Map<String, Object>> reservMap = reservDAO.selectReservation(map);
		// 임의 리스트 객체 생성
		List<String> resultList = new ArrayList<String>();

		// 시간 앞 두자리 뒷 두자리 나눔
		String onhour1 = ((String) HpMap.get("ONHOUR")).substring(0, 2);
		int on1 = Integer.parseInt(onhour1);

		String onhour2 = ((String) HpMap.get("ONHOUR")).substring(2, 4);
		int on2 = Integer.parseInt(onhour2);

		String offhour1 = ((String) HpMap.get("OFFHOUR")).substring(0, 2);
		int off1 = Integer.parseInt(offhour1);

		String offhour2 = ((String) HpMap.get("OFFHOUR")).substring(2, 4);
		int off2 = Integer.parseInt(offhour2);

		String intervall = (String) HpMap.get("INTERVALL");
		int inter = Integer.parseInt(intervall);

		String meal = ((String) HpMap.get("MEAL_TIME")).substring(0, 2);
		int m = Integer.parseInt(meal);

		for (int num = 0; (on1 <= off1 || on2 < off2); on2 += inter) {
			if (on2 >= 60) {
				on1 += 1;
				on2 %= 60;
			}
			String tmpStr = String.format("%02d:%02d", on1, on2);
			if (num < reservMap.size() && ((String) reservMap.get(num).get("RESERV2")).equals(tmpStr)) {
				num++;
				continue;
			}

			if (on1 >= m && on1 < m + 1) {
				on1 += 1;
				on2 = -inter;
				continue;
			}
			tmpStr = String.format("%02d:%02d", on1, on2);
			resultList.add(tmpStr);
		}
		return resultList;
	}

	// 예약하기
	@Override
	public int insertReserv(Map<String, Object> map, Model model, HttpSession session) throws Exception {
		SimpleDateFormat date = new SimpleDateFormat("yyyy/MM/dd");
		String today = date.format(new Date());

		map.put("ID", session.getAttribute("ID"));
		map.put("DATE", today);

		Map<String, Object> UserInfo = mypageDAO.selectUserInfo(map);
		int point = ((BigDecimal) UserInfo.get("POINT")).intValue();
		model.addAttribute("POINT", point);
		
		if (point < 100) {
			return 1;
		} else {
			// 중복확인
			List<Map<String, Object>> templist = reservDAO.selectReservation(map);
			
			for (Map<String, Object> tmp : templist) {
				String tmpH_IDX= ((BigDecimal) tmp.get("H_IDX")).toString();
				String tmpReserv1 = tmp.get("RESERV1").toString();
	
				// 중복 예약 불가
				if (tmpH_IDX.equals(map.get("H_IDX")) && tmpReserv1.equals(map.get("RESERV1"))) {
					return 2;
				}
			}

			mypageDAO.updatePoint2(map);
			reservDAO.insertReserv(map);

			return 0;
		}
	}

	// 예약 내역
	@Override
	public List<Map<String, Object>> selectReservation(Map<String, Object> map, HttpSession session) throws Exception {
		SimpleDateFormat date = new SimpleDateFormat("yyyy/MM/dd");
		String today = date.format(new Date());

		map.put("DATE", today);
		map.put("ID", session.getAttribute("ID"));

		// List<Map<String, Object>> reservList = reservDAO.selectReservation(map);

		reservDAO.pastReserv(map);
		// 예약 내역에서 오늘날짜 이전 날이 있으면 DEL_CHK를 B -> A로 변경해주고 이거는 나중에 로그인 했을 때 업로드 되게
		// 바꿀것!!!!!!!!!!!!

		return reservDAO.selectReservation(map);// 리스트를 다시 출력
	}

	// 지난 예약 내역
	@Override
	public List<Map<String, Object>> selectPastReservation(Map<String, Object> map, HttpSession session)
			throws Exception {
		map.put("ID", session.getAttribute("ID"));

		List<Map<String, Object>> pastreservList = reservDAO.selectPastReservation(map);

		for (Map<String, Object> tmp : pastreservList) {
			String temp = (String) tmp.get("DEL_CHK");

			if (temp.equals("A")) {
				tmp.remove("STATE");
				tmp.put("STATE", "기간만료");
			} else if (temp.equals("C")) {
				tmp.remove("STATE");
				tmp.put("STATE", "예약취소");
			}
		}

		return pastreservList;
	}

	// 예약 취소
	@Override
	public void cancelReserv(Map<String, Object> map, HttpSession session) throws Exception {
		String[] temp = ((String) map.get("H_IDX")).split(",");
		map.put("ID", session.getAttribute("ID"));
		for (int i = 0; i < temp.length; i++) {
			map.remove("H_IDX");
			map.put("H_IDX", temp[i]);

			reservDAO.cancelReserv(map);
			mypageDAO.returnPoint(map);
		}
	}

	@Override
	public List<Map<String, Object>> selectAdminReservList(Map<String, Object> map, Model model, HttpSession session)
			throws Exception {
		if (session.getAttribute("ID").equals("admin"))
			return reservDAO.selectAdminReservList(map);
		else
			return null;
	}
}
