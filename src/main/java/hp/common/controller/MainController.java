package hp.common.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import hp.common.service.CommonService;
import hp.common.common.CommandMap;

@Controller
public class MainController {
   @Resource(name = "commonService")
   private CommonService commonService;
   
   @RequestMapping("/main")
   public String mainForm(CommandMap commandMap, Model model) throws Exception {
      model.addAttribute("body", "body");
      
      List<Map<String, Object>> list = commonService.selectCount(commandMap.getMap());
      model.addAttribute("list", list);
      
      List<Map<String, Object>> reviewlist = commonService.selectReview(commandMap.getMap());
      model.addAttribute("reviewlist", reviewlist);
      
      return "mainForm";
   }
}