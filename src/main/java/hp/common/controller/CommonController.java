package hp.common.controller;

import java.io.File;
import java.net.URLEncoder;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import hp.common.common.CommandMap;
import hp.common.service.CommonService;

@Controller
public class CommonController {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "commonService")
	private CommonService commonService;

	@RequestMapping(value = "/common/downloadFile")
	public void downloadFile(CommandMap commandMap, HttpServletResponse response) throws Exception {
		Map<String, Object> map = commonService.selectFileInfo(commandMap.getMap());
		String storedFileName = (String) map.get("SAVE_FILE");
		String originalFileName = (String) map.get("ORG_FILE");

		// first.common.util.FileUtils가 아니라 org.apache.commons.io.FileUtils이다.
		byte fileByte[] = FileUtils.readFileToByteArray(new File("C:\\Java\\Spring\\hospital2\\src\\main\\webapp\\file\\" + storedFileName));

		response.setContentType("application/octet-stream");
		
		response.setContentLength(fileByte.length);
		
		response.setHeader("Content-Disposition", "attachment; fileName=\"" + URLEncoder.encode(originalFileName, "UTF-8") + "\";");
		response.setHeader("Content-Transfer-Encoding", "binary");
		
		response.getOutputStream().write(fileByte);
		
		response.getOutputStream().flush();
		response.getOutputStream().close();
	}
}