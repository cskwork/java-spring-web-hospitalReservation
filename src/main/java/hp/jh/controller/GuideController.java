package hp.jh.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/guide")
public class GuideController {
	@RequestMapping("/searchGuide")
	public String search(Model model) throws Exception {
		model.addAttribute("body", "searchGuide");
		
		return "mainForm";
	}
	
	@RequestMapping("/reservationGuide")
	public String reservation(Model model) throws Exception {
		model.addAttribute("body", "reservationGuide");
		
		return "mainForm";
	}
	
	@RequestMapping("/ratingGuide")
	public String rating(Model model) throws Exception {
		model.addAttribute("body", "ratingGuide");
		
		return "mainForm";
	}
}