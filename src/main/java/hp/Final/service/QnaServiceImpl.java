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

	@Override
	public List<Map<String, Object>> selectQnaList(Map<String, Object> map) throws Exception {// ����Ʈ ��ȸ
		return qnaDAO.selectQnaList(map);
	}

	@Override
	public void insertQna(Map<String, Object> map) throws Exception { // �Խñ� �ۼ�
		qnaDAO.insertQna(map);
	}

	@Override
	public Map<String, Object> selectQDetail(Map<String, Object> map) throws Exception { // ���� �󼼺���
		return qnaDAO.selectQDetail(map);
	}

	@Override
	public Map<String, Object> selectADetail(Map<String, Object> map) throws Exception { // �亯 �󼼺���
		return qnaDAO.selectADetail(map);
	}

	@Override
	public void updateQna(Map<String, Object> map) throws Exception { // �Խñ� ����
		qnaDAO.updateQna(map);
	}

	@Override
	public void deleteQna(Map<String, Object> map) throws Exception { // �Խñ� ����
		String[] temp = ((String) map.get("IDX")).split(",");

		for (String s : temp) {
			map.remove("IDX");
			map.put("IDX", s);

			qnaDAO.deleteQna(map);
		}
	}
}