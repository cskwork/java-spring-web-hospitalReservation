package hp.common.service;

import java.util.List;
import java.util.Map;

public interface CommonService {
	Map<String, Object> selectFileInfo(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> selectCount(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> selectReview(Map<String, Object> map) throws Exception;
}
