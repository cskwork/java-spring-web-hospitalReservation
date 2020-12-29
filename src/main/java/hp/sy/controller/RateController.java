package hp.sy.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import hp.Final.service.RateService;
import hp.common.common.CommandMap;

@Controller
@RequestMapping("/rate")
public class RateController {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "rateService")
	private RateService rateService;

	// 만족도조사가능한 목록
	@RequestMapping("/RatingList")
	public String ratingList(CommandMap commandMap, Model model, HttpSession session) throws Exception {
		List<Map<String, Object>> list = rateService.reservList(commandMap.getMap(), session);
		
		model.addAttribute("list", list);
		model.addAttribute("body", "ratingList");
		
		return "mainForm";
	}

	// 만족도 조사하기 폼
	@RequestMapping("/OpenRating")
	public String openRating(CommandMap commandMap, Model model) throws Exception {
		model.addAttribute("H_IDX", commandMap.getMap().get("H_IDX"));
		model.addAttribute("RESERV1", commandMap.getMap().get("RESERV1"));
		model.addAttribute("NUM", commandMap.getMap().get("NUM"));
		model.addAttribute("body", "ratingWrite");
		
		return "mainForm";
	}

	// 만족도 조사하기
	@RequestMapping("/Rating")
	public String rating(CommandMap commandMap, Model model) throws Exception {
		rateService.insertRating(commandMap.getMap());

		model.addAttribute("ID", commandMap.getMap().get("ID"));

		return "redirect:/rate/RatingList";
	}
}
