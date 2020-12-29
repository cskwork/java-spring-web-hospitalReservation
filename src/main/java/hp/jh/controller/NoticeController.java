package hp.jh.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import hp.Final.service.NoticeService;
import hp.common.common.CommandMap;

@Controller
@RequestMapping("/notice")
public class NoticeController {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "noticeService")
	private NoticeService noticeService;

	@RequestMapping("/listform")
	public String noticeListForm(CommandMap commandMap, Model model) throws Exception {
		model.addAttribute("body", "noticeList");

		return "mainForm";
	}

	@RequestMapping("/list")
	public String noticeList(CommandMap commandMap, Model model) throws Exception {
		List<Map<String, Object>> list = noticeService.selectNoticeList(commandMap.getMap());
		
		model.addAttribute("list", list);
		
		if (list.size() > 0)
			model.addAttribute("TOTAL", list.get(0).get("TOTAL_COUNT"));
		else
			model.addAttribute("TOTAL", 0);
		
		return "jsonView";
	}

	@RequestMapping("/detail")
	public String noticeDetail(CommandMap commandMap, Model model) throws Exception {
		Map<String, Object> map = noticeService.selectNoticeDetail(commandMap.getMap());
		
		model.addAttribute("map", map.get("map"));
		model.addAttribute("list", map.get("list"));
		model.addAttribute("body", "noticeDetail");
		
		return "mainForm";
	}
}