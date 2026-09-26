package hp.common.util;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

@Component("fileUtils")
public class FileUtils {
	private static String storage() {String configured=System.getenv("DRHER_UPLOAD_DIR");if(configured==null||configured.trim().isEmpty())throw new IllegalStateException("Upload directory not configured");return java.nio.file.Paths.get(configured).toAbsolutePath().normalize().toString()+File.separator;}
    private static void validate(MultipartFile file){String n=file.getOriginalFilename();if(n==null||!n.matches("[\\w가-힣 .-]+\\.(txt|pdf|png|jpg|jpeg)")||file.getSize()>10000000)throw new IllegalArgumentException("Invalid attachment filename or size");}

	public List<Map<String, Object>> parseInsertFileInfo(Map<String, Object> map, HttpServletRequest request)
			throws Exception {
		MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
		Iterator<String> iterator = multipartHttpServletRequest.getFileNames();

		MultipartFile multipartFile = null;
		String originalFileName = null;
		String originalFileExtension = null;
		String storedFileName = null;

		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		Map<String, Object> listMap = null;

		String boardIdx = (String) map.get("IDX");

		File file = new File(storage());
		if (file.exists() == false) {
			file.mkdirs();
		}

		while (iterator.hasNext()) {
			multipartFile = multipartHttpServletRequest.getFile(iterator.next());

			if (multipartFile.isEmpty() == false) {
				validate(multipartFile);
                originalFileName = multipartFile.getOriginalFilename();
				originalFileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
				storedFileName = CommonUtils.getRandomString() + originalFileExtension;

				multipartFile.transferTo(new File(storage(), storedFileName));

				listMap = new HashMap<String, Object>();
				listMap.put("IDX", boardIdx);
				listMap.put("ORG_FILE", originalFileName);
				listMap.put("SAVE_FILE", storedFileName);
				listMap.put("FILE_SIZE", multipartFile.getSize());

				list.add(listMap);
			}
		}
		return list;
	}

	public List<Map<String, Object>> parseUpdateFileInfo(Map<String, Object> map, HttpServletRequest request)
			throws Exception {
		MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
		Iterator<String> iterator = multipartHttpServletRequest.getFileNames();

		MultipartFile multipartFile = null;
		String originalFileName = null;
		String originalFileExtension = null;
		String storedFileName = null;

		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		Map<String, Object> listMap = null;

		String boardIdx = (String) map.get("IDX");
		String requestName = null;
		String idx = null;

		while (iterator.hasNext()) {
			multipartFile = multipartHttpServletRequest.getFile(iterator.next());
			
			if (multipartFile.isEmpty() == false) {
				validate(multipartFile);
                originalFileName = multipartFile.getOriginalFilename();
				originalFileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
				storedFileName = CommonUtils.getRandomString() + originalFileExtension;

				multipartFile.transferTo(new File(storage(), storedFileName));

				listMap = new HashMap<String, Object>();
				listMap.put("IS_NEW", "Y");
				listMap.put("IDX", boardIdx);
				listMap.put("ORG_FILE", originalFileName);
				listMap.put("SAVE_FILE", storedFileName);
				listMap.put("FILE_SIZE", multipartFile.getSize());
				
				list.add(listMap);
			} else {
				requestName = multipartFile.getName();
				idx = "F_IDX_" + requestName.substring(requestName.indexOf("_") + 1);
				
				if (map.containsKey(idx) == true && map.get(idx) != null) {
					listMap = new HashMap<String, Object>();
					listMap.put("IS_NEW", "N");
					listMap.put("F_IDX", map.get(idx));

					list.add(listMap);
				}
			}
		}
		return list;
	}
}