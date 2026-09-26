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
        Map<String,Object> h=reservDAO.selectDate(map);
        List<String> result=new ArrayList<String>(); if(h==null)return result;
        String requested=map.get("RESERV1")==null?String.format("%s/%02d/%02d",map.get("year"),Integer.parseInt(String.valueOf(map.get("month"))),Integer.parseInt(String.valueOf(map.get("day")))):String.valueOf(map.get("RESERV1"));
        java.time.LocalDate date=java.time.LocalDate.parse(requested,java.time.format.DateTimeFormatter.ofPattern("uuuu/MM/dd").withResolverStyle(java.time.format.ResolverStyle.STRICT));
        if(date.isBefore(java.time.LocalDate.now())||date.isAfter(java.time.LocalDate.now().plusDays(7)))return result;
        map.put("RESERV1",requested);
        java.util.Set<String> taken=new java.util.HashSet<String>();for(Map<String,Object> r:reservDAO.takenSlots(map))taken.add(String.valueOf(r.get("RESERV2")));
        String on=String.valueOf(h.get("ONHOUR")),off=String.valueOf(h.get("OFFHOUR"));int from=Integer.parseInt(on.substring(0,2))*60+Integer.parseInt(on.substring(2)),to=Integer.parseInt(off.substring(0,2))*60+Integer.parseInt(off.substring(2)),step=Integer.parseInt(String.valueOf(h.get("INTERVALL"))),meal=Integer.parseInt(String.valueOf(h.get("MEAL_TIME")).substring(0,2));
        if(step<=0||step>240)throw new IllegalArgumentException("Invalid interval");
        for(int m=from;m<to;m+=step){if(m/60==meal)continue;String time=String.format("%02d:%02d",m/60,m%60);if(!taken.contains(time)&&date.atTime(m/60,m%60).isAfter(java.time.LocalDateTime.now().plusMinutes(30)))result.add(time);}return result;
	}

	// 예약하기
	@Override
	@org.springframework.transaction.annotation.Transactional(rollbackFor=Exception.class)
	public int insertReserv(Map<String, Object> map, Model model, HttpSession session) throws Exception {
        hp.common.security.SessionIdentity.bind(map,session);
        Map<String,Object> h=reservDAO.lockHospital(map); if(h==null||!"Y".equals(h.get("REG_CHK")))throw new IllegalArgumentException("Hospital is unavailable");
        Map<String,Object> member=mypageDAO.lockMember(map);if(member==null)throw new SecurityException("Member missing");
        int point=((Number)member.get("POINT")).intValue();model.addAttribute("POINT",point);
        for(Map<String,Object> r:reservDAO.selectReservation(map))if(String.valueOf(r.get("H_IDX")).equals(String.valueOf(map.get("H_IDX")))){
            if(String.valueOf(r.get("RESERV1")).equals(String.valueOf(map.get("RESERV1")))&&String.valueOf(r.get("RESERV2")).equals(String.valueOf(map.get("RESERV2"))))return 0;
            return 2;
        }
        if(!String.valueOf(h.get("MAJOR")).equals(String.valueOf(map.get("CURED")))||!selectDate(map).contains(String.valueOf(map.get("RESERV2"))))throw new IllegalArgumentException("Invalid appointment selection");
        if(point<100)return 1;
        if(mypageDAO.updatePoint2(map)!=1)throw new IllegalStateException("Point debit failed");reservDAO.insertReserv(map);model.addAttribute("POINT",point-100);return 0;
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
	@org.springframework.transaction.annotation.Transactional(rollbackFor=Exception.class)
	public void cancelReserv(Map<String, Object> map, HttpSession session) throws Exception {
        hp.common.security.SessionIdentity.bind(map,session);
        String[] ids=String.valueOf(map.get("H_IDX")).split(",");java.util.Arrays.sort(ids);
        for(String id:ids){map.put("H_IDX",id);reservDAO.lockHospital(map);mypageDAO.lockMember(map);int changed=reservDAO.cancelReserv(map);for(int i=0;i<changed;i++)mypageDAO.returnPoint(map);}
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
