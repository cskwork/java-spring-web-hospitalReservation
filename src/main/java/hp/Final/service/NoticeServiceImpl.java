package hp.Final.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import hp.Final.dao.NoticeDAO;

@Service("noticeService")
public class NoticeServiceImpl implements NoticeService {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "NoticeDAO")
	private NoticeDAO noticeDAO;

	@Override
	public List<Map<String, Object>> selectNoticeList(Map<String, Object> map) throws Exception { // ����Ʈ ��ȸ
		return noticeDAO.selectNoticeList(map);
	}

	@Override
	public Map<String, Object> selectNoticeDetail(Map<String, Object> map) throws Exception {
		noticeDAO.updateHits(map);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> tempMap = noticeDAO.selectNoticeDetail(map);
		
		String REG = tempMap.get("REG").toString();
		REG = REG.substring(0, REG.length() - 5);
		
		tempMap.remove("REG");
		tempMap.put("REG", REG);
		
		resultMap.put("map", tempMap);

		List<Map<String, Object>> list = noticeDAO.selectFileList(map);

		resultMap.put("list", list);

		return resultMap;
	}
}