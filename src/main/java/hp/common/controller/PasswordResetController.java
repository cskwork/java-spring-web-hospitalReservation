package hp.common.controller;
import java.util.Map;import javax.annotation.Resource;import javax.servlet.http.HttpSession;import org.springframework.stereotype.Controller;import org.springframework.web.bind.annotation.*;import hp.common.service.PasswordResetService;
@Controller @RequestMapping("/api/password") public class PasswordResetController {
 @Resource(name="passwordResetService") private PasswordResetService service;
 @RequestMapping(value="/request",method=RequestMethod.POST) @ResponseBody public Map<String,Object> request(@RequestParam("ID")String id)throws Exception{return service.request(id);}
 @RequestMapping(value="/confirm",method=RequestMethod.POST) @ResponseBody public Map<String,Object> confirm(@RequestParam("TOKEN")String token,@RequestParam("PWD")String password,HttpSession session)throws Exception{Map<String,Object> result=service.confirm(token,password);session.invalidate();return result;}
}
