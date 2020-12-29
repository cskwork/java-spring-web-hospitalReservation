
package hp.Final.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.ui.Model;

public interface ReservService {
	// ReservService
	// 예약가능한 병원명 목록
	List<Map<String, Object>> selectHpList(Map<String, Object> map) throws Exception;

	// 병원별 진료시작시간, 진료마감시간, 점심시간
	List<String> selectDate(Map<String, Object> map) throws Exception;

	// 예약내역 목록
	List<Map<String, Object>> selectReservation(Map<String, Object> map, HttpSession session) throws Exception;

	// 지난예약내역 목록
	List<Map<String, Object>> selectPastReservation(Map<String, Object> map, HttpSession session) throws Exception;

	// 예약하기
	int insertReserv(Map<String, Object> map, Model model, HttpSession session) throws Exception;

	// 예약취소
	void cancelReserv(Map<String, Object> map, HttpSession session) throws Exception;
	
	// 관리자-예약 목록
	List<Map<String, Object>> selectAdminReservList(Map<String, Object> map, Model model, HttpSession session) throws Exception;
}
