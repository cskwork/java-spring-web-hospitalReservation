package hp.Final.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import hp.Final.dao.FaqDAO;

@Service("faqService")
public class FaqServiceImpl implements FaqService {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "FaqDAO")
	private FaqDAO faqDAO;

	@Override
	public List<Map<String, Object>> selectFaqList(Map<String, Object> map) throws Exception { // ����Ʈ ��ȸ
		return faqDAO.selectFaqList(map);
	}

	@Override
	public Map<String, Object> selectFaqDetail(Map<String, Object> map) throws Exception { // �Խñ� �󼼺���
		return faqDAO.selectFaqDetail(map);
	}
}