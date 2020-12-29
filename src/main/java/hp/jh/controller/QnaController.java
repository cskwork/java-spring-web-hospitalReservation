package hp.jh.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import hp.Final.service.QnaService;
import hp.common.common.CommandMap;

@Controller
@RequestMapping("/qna")
public class QnaController {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "qnaService")
	private QnaService qnaService;

	@RequestMapping("/listform")
	public String qnaListForm(CommandMap commandMap, Model model) throws Exception { // ����Ʈ ��ȸ ��
		model.addAttribute("body", "qnaList");
		
		return "mainForm";
	}

	@RequestMapping("/list")
	public String qnaList(CommandMap commandMap, Model model) throws Exception { // ����Ʈ ��ȸ ó��
		List<Map<String, Object>> list = qnaService.selectQnaList(commandMap.getMap());

		model.addAttribute("list", list);

		if (list.size() > 0)
			model.addAttribute("TOTAL", list.get(0).get("TOTAL_COUNT"));
		else
			model.addAttribute("TOTAL", 0);

		return "jsonView";
	}

	@RequestMapping("/detail")
	public String qnaDetail(CommandMap commandMap, Model model) throws Exception { // �� ����
		Map<String, Object> map1 = qnaService.selectQDetail(commandMap.getMap());
		Map<String, Object> map2 = qnaService.selectADetail(commandMap.getMap());
		model.addAttribute("body", "qnaDetail");
		model.addAttribute("map1", map1);
		model.addAttribute("map2", map2);

		return "mainForm";
	}

	@RequestMapping("/writeform")
	public String qnaWriteForm(CommandMap commandMap, Model model) throws Exception { // �ۼ� ��
		model.addAttribute("body", "qnaWrite");
		return "mainForm";
	}

	@RequestMapping("/write")
	public String qnaWrite(CommandMap commandMap, Model model) throws Exception { // �ۼ� ó��
		qnaService.insertQna(commandMap.getMap());

		return "redirect:/qna/listform";
	}

	@RequestMapping("/modifyform")
	public String qnaModifyform(CommandMap commandMap, Model model) throws Exception { // ���� ��
		Map<String, Object> map = qnaService.selectQDetail(commandMap.getMap());
		
		model.addAttribute("body", "qnaWrite");
		model.addAttribute("map", map);

		return "mainForm";
	}

	@RequestMapping("/modify")
	public String qnaModify(CommandMap commandMap, Model model) throws Exception { // ���� ó��
		qnaService.updateQna(commandMap.getMap());

		model.addAttribute("IDX", commandMap.get("IDX"));
		model.addAttribute("CHK", commandMap.get("CHK"));

		return "redirect:/qna/listform";
	}

	@RequestMapping("/delete")
	public String qnaDelete(CommandMap commandMap, Model model) throws Exception { // ����
		qnaService.deleteQna(commandMap.getMap());

		return "redirect:/qna/listform";
	}
}