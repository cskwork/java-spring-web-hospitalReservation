package hp.jw.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import hp.Final.service.AdminService;

@Controller
@RequestMapping("/admin")
public class AdminController {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "adminService")
	private AdminService adminService;

	@RequestMapping("/AdminMultiModify")
	public String AdminMultiModify(@RequestParam Map<String, Object> parameters) throws Exception {
		String json = parameters.get("list").toString();
		ObjectMapper mapper = new ObjectMapper();
		List<Map<String, Object>> list = mapper.readValue(json, new TypeReference<ArrayList<Map<String, Object>>>(){});
		
		adminService.AdminMultiModify(list, parameters.get("URL").toString(), (parameters.get("SYSTEM").toString().equals("Multi") ? "Multi" : "Detail"));
		
		return "jsonView";
	}
}