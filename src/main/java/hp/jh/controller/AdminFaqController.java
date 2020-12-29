package hp.jh.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import hp.Final.service.AdminService;
import hp.common.common.CommandMap;

@Controller
@RequestMapping("/admin/faq")
public class AdminFaqController {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "adminService")
	private AdminService adminFaqService;

	@RequestMapping("/listform")
	public String faqListForm(CommandMap commandMap, Model model) throws Exception {
		return "jh/admin/faq/List";
	}

	@RequestMapping("/list")
	public String faqList(CommandMap commandMap, Model model) throws Exception {
		List<Map<String, Object>> list = adminFaqService.selectFaqList(commandMap.getMap());
		
		model.addAttribute("list", list);
		
		if (list.size() > 0)
			model.addAttribute("TOTAL", list.get(0).get("TOTAL_COUNT"));
		else
			model.addAttribute("TOTAL", 0);
		
		return "jsonView";
	}

	@RequestMapping("/writeform")
	public String faqWriteForm(CommandMap commandMap, Model model) throws Exception { // �ۼ� ��
		return "jh/admin/faq/Write";
	}

	@RequestMapping("/write")
	public String faqWrite(CommandMap commandMap, Model model) throws Exception { // �ۼ� ó��
		adminFaqService.insertFaq(commandMap.getMap());
		
		return "redirect:/admin/faq/listform";
	}

	@RequestMapping("/modifyform")
	public String faqModifyform(CommandMap commandMap, Model model) throws Exception { // ���� ��
		Map<String, Object> map = adminFaqService.selectFaqDetail(commandMap.getMap());
		
		model.addAttribute("map", map);
		
		return "jh/admin/faq/Write";
	}

	@RequestMapping("/modify")
	public String faqModify(CommandMap commandMap, Model model) throws Exception { // ���� ó��
		adminFaqService.updateFaq(commandMap.getMap());
		
		model.addAttribute("IDX", commandMap.get("IDX"));
		
		return "redirect:/admin/faq/listform";
	}

	@RequestMapping("/delete")
	public String faqDelete(CommandMap commandMap, Model model) throws Exception { // ����
		adminFaqService.deleteFaq(commandMap.getMap());
		
		return "redirect:/admin/faq/listform";
	}
}