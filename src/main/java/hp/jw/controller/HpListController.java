package hp.jw.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import hp.Final.service.HpListService;
import hp.common.common.CommandMap;

@Controller
@RequestMapping("/hplist")
public class HpListController {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "hplistService")
	private HpListService HpListService;

	@RequestMapping("/test")
	public String test(CommandMap commandMap, Model model) throws Exception {
		return "jw/test";
	}

	@RequestMapping("/List")
	public String openHospitalPage(CommandMap commandMap, Model model) throws Exception {
		model.addAttribute("boardTitle", (String) commandMap.getMap().get("boardTitle"));
		model.addAttribute("LIST", (String) commandMap.getMap().get("LIST"));
		model.addAttribute("QUERY", (String) commandMap.getMap().get("QUERY"));
		model.addAttribute("REG_CHK", (String) commandMap.getMap().get("REG_CHK"));
		model.addAttribute("body", "hplist");
		
		return "mainForm";
	}

	@RequestMapping(value = "/selectHpList",  method = RequestMethod.POST)
	public String selectHospitalList(CommandMap commandMap, Model model, HttpSession session) throws Exception {
		List<Map<String, Object>> list = HpListService.selectBoardList(commandMap.getMap(), session);
		
		model.addAttribute("list", list);

		if (list.size() > 0)
			model.addAttribute("TOTAL", list.get(0).get("TOTAL_COUNT"));
		else
			model.addAttribute("TOTAL", 0);

		return "jsonView";
	}

	@RequestMapping("/HpDetail")
	public String openHpDetail(CommandMap commandMap, Model model) throws Exception {
		Map<String, Object> map = HpListService.selectHpDetail(commandMap.getMap());

		model.addAttribute("map", map);
		model.addAttribute("body", "hpdetail");
		
		return "mainForm";
	}
}
