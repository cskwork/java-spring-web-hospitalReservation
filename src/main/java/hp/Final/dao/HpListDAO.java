package hp.Final.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import hp.common.dao.AbstractDAO;

@SuppressWarnings("unchecked")
@Repository("HpListDAO")
public class HpListDAO extends AbstractDAO {

	public List<Map<String, Object>> selectBoardList(Map<String, Object> map) throws Exception {
		String query=String.valueOf(map.get("QUERY"));
        if(!java.util.Arrays.asList("hplist.selectAllHpList","hplist.selectRateHpList").contains(query)&&!("hplist.selectAdminHpList".equals(query)&&Boolean.TRUE.equals(map.get("SERVER_ADMIN"))))throw new SecurityException("Unknown hospital query");
        return (List<Map<String, Object>>) selectPagingList(query, map);
	}

	public Map<String, Object> selectHpDetail(Map<String, Object> map) throws Exception {
		return (Map<String, Object>) selectOne("hplist.selectHpDetail", map);
	}
}
