package hp.Final.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public interface AdminService {
	List<Map<String, Object>> selectNoticeList(Map<String, Object> map) throws Exception; // �������� ����Ʈ ��ȸ

	void insertNotice(Map<String, Object> map, HttpServletRequest request) throws Exception;// �������� �Խñ� �ۼ�

	Map<String, Object> selectNoticeDetail(Map<String, Object> map) throws Exception; // �������� �Խñ� �󼼺���

	void updateNotice(Map<String, Object> map, HttpServletRequest request) throws Exception;// �������� �Խñ� ����

	void deleteNotice(Map<String, Object> map) throws Exception; // �������� �Խñ� ����

	List<Map<String, Object>> selectFaqList(Map<String, Object> map) throws Exception; // FAQ ����Ʈ ��ȸ

	void insertFaq(Map<String, Object> map) throws Exception; // FAQ �Խñ� �ۼ�

	Map<String, Object> selectFaqDetail(Map<String, Object> map) throws Exception; // FAQ �Խñ� �󼼺���

	void updateFaq(Map<String, Object> map) throws Exception; // FAQ �Խñ� ����

	void deleteFaq(Map<String, Object> map) throws Exception; // FAQ �Խñ� ����

	List<Map<String, Object>> selectQnaList(Map<String, Object> map) throws Exception; // Q&A ����Ʈ ��ȸ

	void insertQna(Map<String, Object> map) throws Exception; // Q&A �亯 �ۼ�

	Map<String, Object> selectQDetail(Map<String, Object> map) throws Exception; // Q&A ���� �󼼺���

	Map<String, Object> selectADetail(Map<String, Object> map) throws Exception; // Q&A �亯 �󼼺���

	void updateQna(Map<String, Object> map) throws Exception; // Q&A �Խñ� ����

	void deleteQna(Map<String, Object> map) throws Exception; // Q&A �Խñ� ����

	void deleteAdminQna(Map<String, Object> map) throws Exception; // Q&A �亯 ����

	List<Map<String, Object>> selectRatingList(Map<String, Object> map) throws Exception; // ���� �ı� ����Ʈ ��ȸ
	
	public void AdminMultiModify(List<Map<String, Object>> list, String URL, String TYPE) throws Exception;
}