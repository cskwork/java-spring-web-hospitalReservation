package hp.Final.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import hp.common.dao.AbstractDAO;

@SuppressWarnings("unchecked")
@Repository("HpListDAO")
public class HpListDAO extends AbstractDAO {

	public List<Map<String, Object>> selectBoardList(Map<String, Object> map) throws Exception {
		return (List<Map<String, Object>>) selectPagingList((String) map.get("QUERY"), map);
	}

	public Map<String, Object> selectHpDetail(Map<String, Object> map) throws Exception {
		return (Map<String, Object>) selectOne("hplist.selectHpDetail", map);
	}
}
