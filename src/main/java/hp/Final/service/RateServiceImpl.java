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
	@org.springframework.transaction.annotation.Transactional(rollbackFor=Exception.class)
	public void insertRating(Map<String, Object> map) throws Exception {
		for (int i=1;i<=4;i++) { int score=Integer.parseInt(String.valueOf(map.get("RATE"+i))); if(score<1||score>5)throw new IllegalArgumentException("Score must be 1 to 5"); map.put("RATE"+i,score); }
		String comment=String.valueOf(map.get("COMM")).trim(); if(comment.length()<2||comment.length()>2000)throw new IllegalArgumentException("Invalid review text");
		Map<String,Object> visit=rateDao.lockVisit(map);
		if(visit==null||!"A".equals(visit.get("DEL_CHK"))||"완료".equals(visit.get("STATE")))throw new SecurityException("Owned completed visit required");
		map.put("H_IDX",visit.get("H_IDX"));
		rateDao.insertRating(map);
		rateDao.updateState(map);
	}
}
