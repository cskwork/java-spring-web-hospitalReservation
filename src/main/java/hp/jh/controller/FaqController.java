package hp.jh.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import hp.Final.service.FaqService;
import hp.common.common.CommandMap;

@Controller
@RequestMapping("/faq")
public class FaqController {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "faqService")
	private FaqService faqService;


	@RequestMapping("/listform")
	public String faqListForm(CommandMap commandMap, Model model) throws Exception { // ����Ʈ ��ȸ ��
		model.addAttribute("body", "faqList");
		return "mainForm";
	}

	@RequestMapping("/list")
	public String faqList(CommandMap commandMap, Model model) throws Exception { // ����Ʈ ��ȸ ó��
		List<Map<String, Object>> list = faqService.selectFaqList(commandMap.getMap());
		
		model.addAttribute("list", list);
		
		if (list.size() > 0)
			model.addAttribute("TOTAL", list.get(0).get("TOTAL_COUNT"));
		else
			model.addAttribute("TOTAL", 0);
		
		return "jsonView";
	}
}