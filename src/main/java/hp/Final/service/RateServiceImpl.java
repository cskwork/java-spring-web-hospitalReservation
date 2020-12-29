package hp.Final.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import hp.Final.dao.RateDAO;

@Service("rateService")
public class RateServiceImpl implements RateService {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "RateDAO")
	private RateDAO rateDao;

	// 만족도 조사 가능한 목록
	@Override
	public List<Map<String, Object>> reservList(Map<String, Object> map, HttpSession session) throws Exception {
		map.put("ID", session.getAttribute("ID"));
		
		List<Map<String, Object>> list = rateDao.reservList(map);

		return list;
	}

	// 만족도 조사하기
	@Override
	public void insertRating(Map<String, Object> map) throws Exception {
		rateDao.insertRating(map);
		rateDao.updateState(map);
	}
}
