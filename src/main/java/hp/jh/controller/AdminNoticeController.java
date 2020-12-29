package hp.jh.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import hp.Final.service.AdminService;
import hp.common.common.CommandMap;

@Controller
@RequestMapping("/admin/notice")
public class AdminNoticeController {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "adminService")
	private AdminService adminNoticeService;

	@RequestMapping("/listform")
	public String noticeListForm(CommandMap commandMap, Model model) throws Exception { // ����Ʈ ��ȸ ��
		return "jh/admin/notice/List";
	}

	@RequestMapping("/list")
	public String noticeList(CommandMap commandMap, Model model) throws Exception { // ����Ʈ ��ȸ ó��
		List<Map<String, Object>> list = adminNoticeService.selectNoticeList(commandMap.getMap());
		
		model.addAttribute("list", list);
		
		if (list.size() > 0) 
			model.addAttribute("TOTAL", list.get(0).get("TOTAL_COUNT"));
		else 
			model.addAttribute("TOTAL", 0);
		
		return "jsonView";
	}

	@RequestMapping("/detail")
	public String noticeDetail(CommandMap commandMap, Model model) throws Exception { // �� ����		
		Map<String, Object> map = adminNoticeService.selectNoticeDetail(commandMap.getMap());
		
		model.addAttribute("map", map.get("map"));
		model.addAttribute("list", map.get("list"));
		
		return "jh/admin/notice/Detail";
	}

	@RequestMapping("/writeform")
	public String noticeWriteForm(CommandMap commandMap, Model model) throws Exception { // �ۼ� ��
		return "jh/admin/notice/Write";
	}

	@RequestMapping("/write")
	public String noticeWrite(CommandMap commandMap, Model model, HttpServletRequest request) throws Exception { // �ۼ� ó��
		adminNoticeService.insertNotice(commandMap.getMap(), request);
		
		return "redirect:/admin/notice/listform";
	}

	@RequestMapping("/modifyform")
	public String noticeModifyform(CommandMap commandMap, Model model) throws Exception { // ���� ��
		Map<String, Object> map = adminNoticeService.selectNoticeDetail(commandMap.getMap());
		
		model.addAttribute("map", map.get("map"));
		model.addAttribute("list", map.get("list"));

		return "jh/admin/notice/Write";
	}

	@RequestMapping("/modify")
	public String noticeModify(CommandMap commandMap, Model model, HttpServletRequest request) throws Exception { // ���� ó��
		adminNoticeService.updateNotice(commandMap.getMap(), request);
		
		model.addAttribute("IDX", commandMap.get("IDX"));
		
		return "redirect:/admin/notice/detail";
	}

	@RequestMapping("/delete")
	public String noticeDelete(CommandMap commandMap, Model model) throws Exception { // ����
		adminNoticeService.deleteNotice(commandMap.getMap());
		
		return "redirect:/admin/notice/listform";
	}
}