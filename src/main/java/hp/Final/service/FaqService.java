package hp.Final.service;

import java.util.List;
import java.util.Map;

public interface FaqService {
	List<Map<String, Object>> selectFaqList(Map<String, Object> map) throws Exception; // ����Ʈ ��ȸ

	Map<String, Object> selectFaqDetail(Map<String, Object> map) throws Exception; // �Խñ� �󼼺���
}