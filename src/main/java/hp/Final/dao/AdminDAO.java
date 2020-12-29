package hp.Final.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import hp.common.dao.AbstractDAO;
@SuppressWarnings("unchecked")
@Repository("AdminDAO")
public class AdminDAO extends AbstractDAO {
	public List<Map<String, Object>> selectNoticeList(Map<String, Object> map) throws Exception{	//�������� ����Ʈ ��ȸ
		return (List<Map<String, Object>>) selectPagingList("notice.selectAdminNoticeList", map);
	}
	public void insertNotice(Map<String, Object> map) throws Exception{								//�������� �� �ۼ�
		insert("notice.insertNotice", map);
	}
	public Map<String, Object> selectNoticeDetail(Map<String, Object> map) throws Exception { 		//�������� �Խñ� �� ����
		return (Map<String, Object>) selectOne("notice.selectNoticeDetail", map);
	}
	public void updateNotice(Map<String, Object> map) throws Exception {							//�������� �Խñ� ����
		update("notice.updateNotice", map);
	}
	public void deleteNotice(Map<String, Object> map) throws Exception {							//�������� �Խñ� ����
		update("notice.deleteNotice", map);
	}
	public void insertFile(Map<String, Object> map) throws Exception{								//�������� ���� ����
		insert("file.insertFile", map);
	}
	public List<Map<String, Object>> selectFileList(Map<String, Object> map) throws Exception{		//�������� ���� ���
		return (List<Map<String, Object>>)selectList("file.selectFileList", map);
	}
	public void deleteFileList(Map<String, Object> map) throws Exception{							//�������� ���� ����
		update("file.deleteFileList", map);
	}
	public void updateFile(Map<String, Object> map) throws Exception{								//�������� ���� ����
		update("file.updateFile", map);
	}
	
	public List<Map<String, Object>> selectFaqList(Map<String, Object> map) throws Exception{		//FAQ ����Ʈ ��ȸ
		return (List<Map<String, Object>>) selectPagingList("faq.selectAdminFaqList", map);
	}
	public void insertFaq(Map<String, Object> map) throws Exception{								//FAQ �� �ۼ�
		insert("faq.insertFaq", map);
	}
	public Map<String, Object> selectFaqDetail(Map<String, Object> map) throws Exception { 			//FAQ �Խñ� �� ����
		return (Map<String, Object>) selectOne("faq.selectFaqDetail", map);
	}
	public void updateFaq(Map<String, Object> map) throws Exception {								//FAQ �Խñ� ����
		update("faq.updateFaq", map);
	}
	public void deleteFaq(Map<String, Object> map) throws Exception {								//FAQ �Խñ� ����
		update("faq.deleteFaq", map);
	}
	
	public List<Map<String, Object>> selectQnaList(Map<String, Object> map) throws Exception{		//Q&A ����Ʈ ��ȸ
		return (List<Map<String, Object>>) selectPagingList("qna.selectAdminQnaList", map);
	}
	public void insertQna(Map<String, Object> map) throws Exception{								//Q&A �亯 �ۼ�
		insert("qna.insertAdminQna", map);
	}
	public Map<String, Object> selectQDetail(Map<String, Object> map) throws Exception { 			//Q&A ���� �� ����
		return (Map<String, Object>) selectOne("qna.selectQDetail", map);
	}
	public Map<String, Object> selectADetail(Map<String, Object> map) throws Exception { 			//Q&A �亯 �� ����
		return (Map<String, Object>) selectOne("qna.selectADetail", map);
	}
	public void updateQna(Map<String, Object> map) throws Exception {								//Q&A �Խñ� ����
		update("qna.updateQna", map);
	}
	public void deleteQna(Map<String, Object> map) throws Exception {								//Q&A �Խñ� ����
		update("qna.deleteQna", map);
	}
	public void deleteAdminQna(Map<String, Object> map) throws Exception {							//Q&A �亯 ����
		delete("qna.deleteAdminQna", map);
	}
	
	public List<Map<String, Object>> selectRatingList(Map<String, Object> map) throws Exception{	//���� �ı� ����Ʈ ��ȸ
		return (List<Map<String, Object>>) selectPagingList("rating.selectAdminRatingList", map);
	}

	public void updateAdminMultiModify(Map<String, Object> map, String queryID) throws Exception {								//Q&A �Խñ� ����
		update(queryID, map);
	}
}