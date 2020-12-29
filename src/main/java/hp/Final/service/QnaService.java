package hp.Final.service;

import java.util.List;
import java.util.Map;

public interface QnaService {
	List<Map<String, Object>> selectQnaList(Map<String, Object> map) throws Exception; // ����Ʈ ��ȸ

	void insertQna(Map<String, Object> map) throws Exception; // �Խñ� �ۼ�

	Map<String, Object> selectQDetail(Map<String, Object> map) throws Exception; // ���� �󼼺���

	Map<String, Object> selectADetail(Map<String, Object> map) throws Exception; // �亯 �󼼺���

	void updateQna(Map<String, Object> map) throws Exception; // �Խñ� ����

	void deleteQna(Map<String, Object> map) throws Exception; // �Խñ� ����
}