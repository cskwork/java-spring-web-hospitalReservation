package hp.Final.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import hp.common.dao.AbstractDAO;

@Repository("FaqDAO")
public class FaqDAO extends AbstractDAO {
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectFaqList(Map<String, Object> map) throws Exception{	//����Ʈ ��ȸ
		return (List<Map<String, Object>>) selectPagingList("faq.selectFaqList", map);
	}
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectFaqDetail(Map<String, Object> map) throws Exception { 		//�Խñ� �� ����
		return (Map<String, Object>) selectOne("faq.selectFaqDetail", map);
	}
}