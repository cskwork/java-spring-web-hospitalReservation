package hp.common.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("commonDAO")
public class CommonDAO extends AbstractDAO{
   @SuppressWarnings("unchecked")
   public Map<String, Object> selectFileInfo(Map<String, Object> map) throws Exception{
      return (Map<String, Object>)selectOne("file.selectFileInfo", map);
   }
   
   @SuppressWarnings("unchecked")
   public Map<String, Object> selectHPCount(Map<String, Object> map) throws Exception {
      return (Map<String, Object>) selectOne("common.selectHPCount", map);
   }
   
   @SuppressWarnings("unchecked")
   public Map<String, Object> selectRATE1Count(Map<String, Object> map) throws Exception {
      return (Map<String, Object>) selectOne("common.selectRATE1Count", map);
   }
   
   @SuppressWarnings("unchecked")
   public Map<String, Object> selectRATE2Count(Map<String, Object> map) throws Exception {
      return (Map<String, Object>) selectOne("common.selectRATE2Count", map);
   }
   
   @SuppressWarnings("unchecked")
   public Map<String, Object> selectMEMBERCount(Map<String, Object> map) throws Exception {
      return (Map<String, Object>) selectOne("common.selectMEMBERCount", map);
   }
   
   @SuppressWarnings("unchecked")
   public List<Map<String, Object>> selectReview(Map<String, Object> map) throws Exception{
      return (List<Map<String, Object>>) selectList("common.selectReview", map);
   }
}