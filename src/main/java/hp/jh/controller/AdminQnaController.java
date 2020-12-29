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
@RequestMapping("/admin/qna")
public class AdminQnaController {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "adminService")
	private AdminService adminQnaService;

	@RequestMapping("/listform")
	public String qnaListForm(CommandMap commandMap, Model model) throws Exception { // ����Ʈ ��ȸ ��
		return "jh/admin/qna/List";
	}

	@RequestMapping("/list")
	public String qnaList(CommandMap commandMap, Model model) throws Exception { // ����Ʈ ��ȸ ó��
		List<Map<String, Object>> list = adminQnaService.selectQnaList(commandMap.getMap());
		
		model.addAttribute("list", list);
		
		if (list.size() > 0)
			model.addAttribute("TOTAL", list.get(0).get("TOTAL_COUNT"));
		else
			model.addAttribute("TOTAL", 0);
		
		return "jsonView";
	}

	@RequestMapping("/detail")
	public String qnaDetail(CommandMap commandMap, Model model) throws Exception { // �� ���� 
		Map<String, Object> map1 = adminQnaService.selectQDetail(commandMap.getMap());
		Map<String, Object> map2 = adminQnaService.selectADetail(commandMap.getMap());
		
		model.addAttribute("map1", map1);
		model.addAttribute("map2", map2);
		
		return "jh/admin/qna/Detail";
	}

	@RequestMapping("/writeform")
	public String qnaWriteForm(CommandMap commandMap, Model model) throws Exception { // �ۼ� ��
		Map<String, Object> map = adminQnaService.selectQDetail(commandMap.getMap());
		
		model.addAttribute("map1", map);
		
		return "jh/admin/qna/Write";
	}

	@RequestMapping("/write")
	public String qnaWrite(CommandMap commandMap, Model model) throws Exception { // �ۼ� ó�
		adminQnaService.insertQna(commandMap.getMap());
		
		return "redirect:/admin/qna/listform";
	}

	@RequestMapping("/modifyform")
	public String qnaModifyform(CommandMap commandMap, Model model) throws Exception { // ���� ��
		Map<String, Object> map1 = adminQnaService.selectQDetail(commandMap.getMap());
		Map<String, Object> map2 = adminQnaService.selectADetail(commandMap.getMap());
		
		model.addAttribute("map1", map1);
		model.addAttribute("map2", map2);
		
		return "jh/admin/qna/Write";
	}

	@RequestMapping("/modify")
	public String qnaModify(CommandMap commandMap, Model model) throws Exception { // ���� ó��
		adminQnaService.updateQna(commandMap.getMap());
		
		model.addAttribute("IDX", commandMap.get("IDX"));
		model.addAttribute("CHK", commandMap.get("CHK"));
		
		return "redirect:/admin/qna/listform";
	}

	@RequestMapping("/delete")
	public String qnaDelete(CommandMap commandMap, Model model) throws Exception { // ����
		adminQnaService.deleteQna(commandMap.getMap());
		
		return "redirect:/admin/qna/listform";
	}

	@RequestMapping("/admindelete")
	public String qnaAdminDelete(CommandMap commandMap, Model model) throws Exception { // �亯 ����
		adminQnaService.deleteAdminQna(commandMap.getMap());
		
		return "redirect:/admin/qna/listform";
	}
}