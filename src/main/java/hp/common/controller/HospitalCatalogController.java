package hp.common.controller;
import java.util.*;import javax.annotation.Resource;import javax.servlet.http.HttpSession;import org.springframework.stereotype.Controller;import org.springframework.ui.Model;import org.springframework.web.bind.annotation.*;import hp.common.service.HospitalCatalogService;
@Controller @RequestMapping("/admin/catalog") public class HospitalCatalogController {
 @Resource(name="hospitalCatalogService") private HospitalCatalogService service;
 @RequestMapping(method=RequestMethod.GET) public String page(Model model,HttpSession session){model.addAttribute("hospitals",service.list(session));return "compat/catalog";}
 @RequestMapping(value="/list",method=RequestMethod.POST) @ResponseBody public List<Map<String,Object>> list(HttpSession session){return service.list(session);}
 @RequestMapping(value="/save",method=RequestMethod.POST) public String save(@RequestParam Map<String,Object> p,HttpSession session){return service.save(p,session);}
 @RequestMapping(value="/remove",method=RequestMethod.POST) public String remove(@RequestParam Map<String,Object> p,HttpSession session){return service.remove(p,session);}
}
