package hp.Final.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

public interface RateService {
	// RateService
	// 만족도조사가능한 목록
	List<Map<String, Object>> reservList(Map<String, Object> map, HttpSession session) throws Exception;

	// 만족도 조사하기
	void insertRating(Map<String, Object> map) throws Exception;
}
