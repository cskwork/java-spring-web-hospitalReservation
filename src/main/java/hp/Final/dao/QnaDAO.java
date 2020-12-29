package hp.Final.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import hp.common.dao.AbstractDAO;

@Repository("QnaDAO")
public class QnaDAO extends AbstractDAO {
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectQnaList(Map<String, Object> map) throws Exception{	//����Ʈ ��ȸ
		return (List<Map<String, Object>>) selectPagingList("qna.selectQnaList", map);
	}
	public void insertQna(Map<String, Object> map) throws Exception{							//�� �ۼ�
		insert("qna.insertQna", map);
	}
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectQDetail(Map<String, Object> map) throws Exception { 		//Q&A ���� �� ����
		return (Map<String, Object>) selectOne("qna.selectQDetail", map);
	}
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectADetail(Map<String, Object> map) throws Exception { 		//Q&A �亯 �� ����
		return (Map<String, Object>) selectOne("qna.selectADetail", map);
	}
	public void updateQna(Map<String, Object> map) throws Exception {							//�Խñ� ����
		update("qna.updateQna", map);
	}
	public void deleteQna(Map<String, Object> map) throws Exception {							//�Խñ� ����
		update("qna.deleteQna", map);
	}
}