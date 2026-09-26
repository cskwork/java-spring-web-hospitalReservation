package hp.Final.service;

import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import hp.Final.dao.AdminDAO;
import hp.common.security.MD5Hash;
import hp.common.util.FileUtils;

@Service("adminService")
public class AdminServiceImpl implements AdminService {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "fileUtils")
	private FileUtils fileUtils;

	@Resource(name = "AdminDAO")
	private AdminDAO adminDAO;

	@Override
	public List<Map<String, Object>> selectNoticeList(Map<String, Object> map) throws Exception { // �������� ����Ʈ ��ȸ
		return adminDAO.selectNoticeList(map);
	}

	@Override
	public void insertNotice(Map<String, Object> map, HttpServletRequest request) throws Exception {// �������� �Խñ� �ۼ�
		adminDAO.insertNotice(map);
		List<Map<String, Object>> list = fileUtils.parseInsertFileInfo(map, request);

		for (int i = 0, size = list.size(); i < size; i++) {
			adminDAO.insertFile(list.get(i));
		}
	}

	@Override
	public Map<String, Object> selectNoticeDetail(Map<String, Object> map) throws Exception { // �������� �Խñ� �󼼺���
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> tempMap = adminDAO.selectNoticeDetail(map);
		resultMap.put("map", tempMap);

		List<Map<String, Object>> list = adminDAO.selectFileList(map);
		resultMap.put("list", list);

		return resultMap;
	}

	@Override
	public void updateNotice(Map<String, Object> map, HttpServletRequest request) throws Exception { // �������� �Խñ�
																										// ����
		adminDAO.updateNotice(map);
		adminDAO.deleteFileList(map);

		List<Map<String, Object>> list = fileUtils.parseUpdateFileInfo(map, request);
		Map<String, Object> tempMap = null;

		for (int i = 0, size = list.size(); i < size; i++) {
			tempMap = list.get(i);
			
			if (tempMap.get("IS_NEW").equals("Y"))
				adminDAO.insertFile(tempMap);
			else
				adminDAO.updateFile(tempMap);
		}
	}

	@Override
	public void deleteNotice(Map<String, Object> map) throws Exception { // �������� �Խñ� ����
		String[] strArr = ((String) map.get("IDX")).split(",");

		for (String tmpStr : strArr) {
			map.remove("IDX");
			map.put("IDX", tmpStr);

			adminDAO.deleteNotice(map);
		}
	}

	@Override
	public List<Map<String, Object>> selectFaqList(Map<String, Object> map) throws Exception { // FAQ ����Ʈ ��ȸ
		return adminDAO.selectFaqList(map);
	}

	@Override
	public void insertFaq(Map<String, Object> map) throws Exception { // FAQ �Խñ� �ۼ�
		adminDAO.insertFaq(map);
	}

	@Override
	public Map<String, Object> selectFaqDetail(Map<String, Object> map) throws Exception { // FAQ �Խñ� �󼼺���
		return adminDAO.selectFaqDetail(map);
	}

	@Override
	public void updateFaq(Map<String, Object> map) throws Exception { // FAQ �Խñ� ����
		adminDAO.updateFaq(map);
	}

	@Override
	public void deleteFaq(Map<String, Object> map) throws Exception { // FAQ �Խñ� ����
		adminDAO.deleteFaq(map);
	}

	@Override
	public List<Map<String, Object>> selectQnaList(Map<String, Object> map) throws Exception { // Q&A ����Ʈ ��ȸ
		return adminDAO.selectQnaList(map);
	}

	@Override
	public void insertQna(Map<String, Object> map) throws Exception { // Q&A �亯 �ۼ�
		adminDAO.insertQna(map);
	}

	@Override
	public Map<String, Object> selectQDetail(Map<String, Object> map) throws Exception { // Q&A ���� �󼼺���
		return adminDAO.selectQDetail(map);
	}

	@Override
	public Map<String, Object> selectADetail(Map<String, Object> map) throws Exception { // Q&A �亯 �󼼺���
		return adminDAO.selectADetail(map);
	}

	@Override
	public void updateQna(Map<String, Object> map) throws Exception { // Q&A �Խñ� ����
		adminDAO.updateQna(map);
	}

	@Override
	public void deleteQna(Map<String, Object> map) throws Exception { // Q&A �Խñ� ����
		adminDAO.deleteQna(map);
	}

	@Override
	public void deleteAdminQna(Map<String, Object> map) throws Exception { // Q&A �亯 ����
		adminDAO.deleteAdminQna(map);
	}

	@Override
	public List<Map<String, Object>> selectRatingList(Map<String, Object> map) throws Exception { // ���� �ı� ����Ʈ ��ȸ
		return adminDAO.selectRatingList(map);
	}

	@Override
	@org.springframework.transaction.annotation.Transactional(rollbackFor=Exception.class)
	public void AdminMultiModify(List<Map<String, Object>> list, String URL, String TYPE) throws Exception {
		if("reserv/AdminReservList".equals(URL)) {
            for(Map<String,Object> p:list){Map<String,Object> original=adminDAO.lockReservation(p);if(original==null)throw new IllegalArgumentException("Reservation not found");String next=String.valueOf(p.get("DEL_CHK"));if(!java.util.Arrays.asList("A","C").contains(next))throw new IllegalArgumentException("Invalid transition");if(next.equals(original.get("DEL_CHK")))continue;if(!"B".equals(original.get("DEL_CHK")))throw new IllegalStateException("Reservation already closed");if("A".equals(next)&&String.valueOf(original.get("RESERV1")).compareTo(new java.text.SimpleDateFormat("yyyy/MM/dd").format(new java.util.Date()))>0)throw new IllegalArgumentException("Future visit cannot be completed");p.put("ID",original.get("ID"));if(adminDAO.transitionReservation(p)!=1)throw new IllegalStateException("Concurrent reservation change");if("C".equals(next))adminDAO.refund(p);}return;
        }
        String queryID = "";
		
		if (TYPE.equals("Multi")) {
			if (URL.equals("member/list2"))
				queryID = "admin.Admin_updateMultiMember";
			else if (URL.equals("hplist/selectHpList"))
				queryID = "admin.Admin_updateMultiHp";
			else if (URL.equals("reserv/AdminReservList"))
				queryID = "admin.Admin_updateMultiReserv";
			else if (URL.equals("admin/notice/list"))
				queryID = "admin.Admin_updateMultiNotice";
			else if (URL.equals("admin/faq/list"))
				queryID = "admin.Admin_updateMultiFaq";
			else if (URL.equals("admin/qna/list"))
				queryID = "admin.Admin_updateMultiQna";
			else if (URL.equals("admin/rating/list"))
				queryID = "admin.Admin_updateMultiRating";
		} else if (TYPE.equals("Detail")) {
			if (URL.equals("member/list2"))
				queryID = "admin.Admin_updateDetailMember";
			else if (URL.equals("hplist/selectHpList"))
				queryID = "admin.Admin_updateDetailHp";
			else if (URL.equals("reserv/AdminReservList"))
				queryID = "admin.Admin_updateDetailReserv";
			else if (URL.equals("admin/notice/list"))
				queryID = "admin.Admin_updateDetailNotice";
			else if (URL.equals("admin/faq/list"))
				queryID = "admin.Admin_updateDetailFaq";
			else if (URL.equals("admin/qna/list"))
				queryID = "admin.Admin_updateDetailQna";
			else if (URL.equals("admin/rating/list"))
				queryID = "admin.Admin_updateDetailRating";
		}

		if(queryID.isEmpty())throw new IllegalArgumentException("Unknown administrative operation");
        if(list.size()>100)throw new IllegalArgumentException("At most 100 rows per operation");
		for (Map<String, Object> tmpMap : list) {
            for(String key:new String[]{"NAME","ADDR","HOSP","H_COMM","DOC_COMM","TITLE","CONTENT","Q","A","COMM"})if(tmpMap.get(key)!=null)tmpMap.put(key,org.springframework.web.util.HtmlUtils.htmlEscape(String.valueOf(tmpMap.get(key))));
			if (tmpMap.get("PWD") != null && !tmpMap.get("PWD").equals("비공개"))
				tmpMap.put("PWD", hp.common.security.PasswordHash.hash((String) tmpMap.get("PWD")));

			if (tmpMap.get("REG") != null)
				tmpMap.put("REG", new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").parse((String) tmpMap.get("REG")));

			adminDAO.updateAdminMultiModify(tmpMap, queryID);
		}
	}
}