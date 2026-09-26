package hp.Final.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import hp.Final.dao.QnaDAO;

@Service("qnaService")
public class QnaServiceImpl implements QnaService {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "QnaDAO")
	private QnaDAO qnaDAO;
    private void owned(Map<String,Object> map)throws Exception {Map<String,Object> q=qnaDAO.selectQDetail(map);if(q==null||map.get("ID")==null||!String.valueOf(q.get("ID")).equals(String.valueOf(map.get("ID"))))throw new SecurityException("Owned inquiry required");}
    private void validate(Map<String,Object> map){for(String k:new String[]{"TITLE","CONTENT"}){String v=String.valueOf(map.get(k));if(v.trim().length()<1||v.length()>4000||"null".equals(v))throw new IllegalArgumentException("Invalid inquiry content");}map.put("CHK",0);}


	@Override
	public List<Map<String, Object>> selectQnaList(Map<String, Object> map) throws Exception {// ����Ʈ ��ȸ
		return qnaDAO.selectQnaList(map);
	}

	@Override
	public void insertQna(Map<String, Object> map) throws Exception { // �Խñ� �ۼ�
		validate(map);qnaDAO.insertQna(map);
	}

	@Override
	public Map<String, Object> selectQDetail(Map<String, Object> map) throws Exception { // ���� �󼼺���
		owned(map);return qnaDAO.selectQDetail(map);
	}

	@Override
	public Map<String, Object> selectADetail(Map<String, Object> map) throws Exception { // �亯 �󼼺���
		owned(map);return qnaDAO.selectADetail(map);
	}

	@Override
	public void updateQna(Map<String, Object> map) throws Exception { // �Խñ� ����
		owned(map);validate(map);qnaDAO.updateQna(map);
	}

	@Override
	@org.springframework.transaction.annotation.Transactional(rollbackFor=Exception.class)
	public void deleteQna(Map<String, Object> map) throws Exception { // �Խñ� ����
		String[] temp = ((String) map.get("IDX")).split(",");

		for (String s : temp) {
			map.remove("IDX");
			map.put("IDX", s);

			owned(map);qnaDAO.deleteQna(map);
		}
	}
}