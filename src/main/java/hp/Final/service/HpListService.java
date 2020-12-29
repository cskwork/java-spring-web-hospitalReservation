package hp.Final.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

public interface HpListService {
	List<Map<String, Object>> selectBoardList(Map<String, Object> map, HttpSession session) throws Exception;
	
	Map<String, Object> selectHpDetail(Map<String, Object> map) throws Exception;
}
