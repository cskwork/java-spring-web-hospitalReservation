package hp.Final.service;

import java.util.List;
import java.util.Map;

public interface NoticeService {
	List<Map<String, Object>> selectNoticeList(Map<String, Object> map) throws Exception; // ����Ʈ ��ȸ

	Map<String, Object> selectNoticeDetail(Map<String, Object> map) throws Exception; // �Խñ� �󼼺��� & ��ȸ�� ����
}