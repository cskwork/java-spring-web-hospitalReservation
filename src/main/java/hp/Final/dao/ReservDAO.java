package hp.Final.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import hp.common.dao.AbstractDAO;

@SuppressWarnings("unchecked")
@Repository("ReservDAO")
public class ReservDAO extends AbstractDAO {
	// 예약 가능한 병원 리스트
	public List<Map<String, Object>> selectHpList(Map<String, Object> map) throws Exception {
		return (List<Map<String, Object>>) selectList("reserv.selectHpList", map);
	}

	// 예약내역 리스트
	public List<Map<String, Object>> selectReservation(Map<String, Object> map) throws Exception {
		return (List<Map<String, Object>>) selectList("reserv.selectReservation", map);
	}

	// 지난예약 리스트
	public List<Map<String, Object>> selectPastReservation(Map<String, Object> map) throws Exception {
		return (List<Map<String, Object>>) selectList("reserv.selectPastReservation", map);
	}

	// 예약가능 시간 계산을 위한 시간컬럼 가져오기
	public Map<String, Object> selectDate(Map<String, Object> map) throws Exception {
		return (Map<String, Object>) selectOne("reserv.selectDate", map);
	}

	// 예약하기
	public void insertReserv(Map<String, Object> map) throws Exception {
		insert("reserv.insertReserv", map);
	}

	// 예약취소하기
	public void cancelReserv(Map<String, Object> map) throws Exception {
		update("reserv.cancelReserv", map);
	}

	// 지난예약으로 변경하기
	public void pastReserv(Map<String, Object> map) throws Exception {
		update("reserv.pastReserv", map);
	}
	
	public List<Map<String, Object>> selectAdminReservList(Map<String, Object> map) throws Exception {
		return (List<Map<String, Object>>) selectPagingList("reserv.selectAdminReservList", map);
	}
}
