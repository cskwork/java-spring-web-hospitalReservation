package hp.Final.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import hp.common.dao.AbstractDAO;

@Repository("NoticeDAO")
public class NoticeDAO extends AbstractDAO {
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectNoticeList(Map<String, Object> map) throws Exception{	//����Ʈ ��ȸ
		return (List<Map<String, Object>>) selectPagingList("notice.selectNoticeList", map);
	}
	public void updateHits(Map<String, Object> map) throws Exception { 								//��ȸ�� ����
		update("notice.updateHits", map);
	}
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectNoticeDetail(Map<String, Object> map) throws Exception { 		//�Խñ� �� ����
		return (Map<String, Object>) selectOne("notice.selectNoticeDetail", map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectFileList(Map<String, Object> map) throws Exception{		//���� ���
		return (List<Map<String, Object>>)selectList("file.selectFileList", map);
	}
}