package hp.Final.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import hp.common.dao.AbstractDAO;

@SuppressWarnings("unchecked")
@Repository("RateDAO")
public class RateDAO extends AbstractDAO {
	// 만족도조사가능한 목록
	public List<Map<String, Object>> reservList(Map<String, Object> map) throws Exception {
		return (List<Map<String, Object>>) selectList("rate.reservList", map);
	}

	// 만족도 조사하기
	public void insertRating(Map<String, Object> map) throws Exception {
		insert("rate.insertRating", map);
	}

	// 만족도 조사 시 상태바꾸기
	public void updateState(Map<String, Object> map) throws Exception {
		update("rate.updateState", map);
	}
}
